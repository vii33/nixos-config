# macOS + Nix proxy debugging notes (Dec 19, 2025)

## Symptom
- Running `nix run nix-darwin -- switch --flake .#work` fails with cache timeouts, e.g.
  - `unable to download 'https://cache.nixos.org/...narinfo': Timeout was reached (28) ... after 15002 milliseconds`

## What worked / what failed
- A normal build like `nix build nixpkgs#hello` is not a reliable cache test; it may build locally or reuse existing store paths.
- A “must-substitute” build was used to force cache access:
  - `nix build nixpkgs#hello --no-link --option builders "" -L`
  - This also failed, consistent with “can’t fetch from caches”.

## Effective Nix settings observed
- `connect-timeout = 15` (matches the ~15s timeout in the error)
- `substituters = https://cache.nixos.org/` (cache is configured, but unreachable from the process doing downloads)

## Installation mode: multi-user daemon is present
- `launchctl list | grep org.nixos.nix-daemon` did not show the job, but the daemon process exists:
  - `ps aux | egrep 'nix-daemon'` showed:
    - `/nix/var/nix/profiles/default/bin/nix-daemon` (running as `root`)
- Consequence: downloads/substitutions are typically performed by `nix-daemon` (root), which does **not** automatically inherit your interactive shell’s proxy environment.

## Proxy environment in the interactive shell
- Terminal environment contained:
  - `HTTP_PROXY=http://localhost:3128`
  - `HTTPS_PROXY=http://localhost:3128`
  - `NO_PROXY=127.0.0.1,localhost,...`
- This explains why “proxy tunneling tests” can pass from the terminal but Nix cache fetches can still fail.

## Where the Nix config lives (and what it currently contains)
- System config directories exist and mirror each other on macOS:
  - `/etc/nix/`
  - `/private/etc/nix/`
- Files present (examples):
  - `nix.conf`
  - `nix.custom.conf`
  - `nix.conf.bak.*`
- `/etc/nix/nix.conf` includes:
  - `!include nix.custom.conf`
  - plus Determinate Nix Installer header/comments
  - plus these proxy lines:
    - `http-proxy = http://127.0.0.1:3128`
    - `https-proxy = http://127.0.0.1:3128`

## Why Nix prints “unknown setting 'http-proxy'”
- `nix config show` printed:
  - `warning: unknown setting 'http-proxy'`
  - `warning: unknown setting 'https-proxy'`
- Nix version:
  - `nix (Nix) 2.32.4`
- Conclusion:
  - In this Nix version, `http-proxy` / `https-proxy` are **not valid** `nix.conf` keys.
  - These lines do not configure proxying for Nix; they only produce warnings.

## Launchd job inspection
- `launchctl print system/org.nixos.nix-daemon | egrep ...` did not show any proxy-related environment variables.
- Conclusion:
  - Even though the terminal has `HTTP_PROXY/HTTPS_PROXY`, `nix-daemon` likely has none, so it tries to access `cache.nixos.org` directly and times out behind the corporate network.

## Working hypothesis
- The cache timeout is caused by missing proxy configuration for the **daemon context** (root / launchd), not by a broken proxy tunnel from the interactive shell.

## Next actions 

### 1) (Optional) Remove invalid proxy keys from `nix.conf` (stops warnings)

Nix 2.32.4 treats `http-proxy` / `https-proxy` as **unknown settings**. Keeping them is harmless (just warnings), but removing them makes `nix` output less noisy.

```sh
sudo cp -a /etc/nix/nix.conf "/etc/nix/nix.conf.bak.$(date +%Y%m%d%H%M%S)"
sudo sed -i '' -E '/^(http-proxy|https-proxy)\s*=/d' /etc/nix/nix.conf
sudo grep -nE '^(http-proxy|https-proxy)\s*=' /etc/nix/nix.conf || echo 'OK: no proxy keys left'
```

### 2) Give `nix-daemon` the proxy via launchd system environment

Because `nix-daemon` runs as root under launchd, it usually won’t inherit your terminal’s `HTTP_PROXY`/`HTTPS_PROXY`.

Step 2b worked. <<<

#### 2a) Attempt: `launchctl setenv` (may be blocked by SIP)

On some macOS setups, setting system-wide launchd environment variables is blocked by System Integrity Protection (SIP), e.g.

`Could not set environment: 150: Operation not permitted while System Integrity Protection is engaged`

If it works on your machine, it’s the simplest approach:

```sh
sudo launchctl setenv HTTP_PROXY  'http://127.0.0.1:3128'
sudo launchctl setenv HTTPS_PROXY 'http://127.0.0.1:3128'

# Some tooling reads lowercase variants
sudo launchctl setenv http_proxy  'http://127.0.0.1:3128'
sudo launchctl setenv https_proxy 'http://127.0.0.1:3128'

# Adjust to your real NO_PROXY list
sudo launchctl setenv NO_PROXY  '127.0.0.1,localhost,.bmwgroup.net,.cloud.bmw'
sudo launchctl setenv no_proxy  '127.0.0.1,localhost,.bmwgroup.net,.cloud.bmw'

# sanity check
sudo launchctl getenv HTTP_PROXY
sudo launchctl getenv HTTPS_PROXY
sudo launchctl getenv NO_PROXY
```

Restart the daemon (label can vary by installer; try the first, then fallback):

```sh
sudo launchctl kickstart -k system/org.nixos.nix-daemon \
  || sudo launchctl kickstart -k system/org.nixos.nix-daemon.service

ps aux | egrep 'nix-daemon' | grep -v egrep
```

#### 2b) SIP-compatible approach: put proxy env vars into the `nix-daemon` LaunchDaemon plist

If SIP blocks `launchctl setenv`, configure environment variables directly on the daemon’s LaunchDaemon plist instead.

1) Find the plist:

```sh
sudo ls -la /Library/LaunchDaemons | egrep -i 'nix|determinate'
```

Common names include:
- `/Library/LaunchDaemons/org.nixos.nix-daemon.plist`
- (Determinate installer variants) a plist containing `nix-daemon` in its `ProgramArguments`

2) Inspect to confirm it’s the right one:

```sh
sudo plutil -p /Library/LaunchDaemons/org.nixos.nix-daemon.plist | head
sudo /usr/libexec/PlistBuddy -c 'Print :ProgramArguments' /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

3) Add/update `EnvironmentVariables` (single sudo session - only one password prompt):

```sh
plist=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo sh -c "
  /usr/libexec/PlistBuddy -c 'Add :EnvironmentVariables dict' '$plist' 2>/dev/null || true
  
  for var in HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
    /usr/libexec/PlistBuddy -c \"Add :EnvironmentVariables:\$var string http://127.0.0.1:3128\" '$plist' 2>/dev/null || \
    /usr/libexec/PlistBuddy -c \"Set :EnvironmentVariables:\$var http://127.0.0.1:3128\" '$plist'
  done
  
  for var in NO_PROXY no_proxy; do
    /usr/libexec/PlistBuddy -c \"Add :EnvironmentVariables:\$var string 127.0.0.1,localhost,.bmwgroup.net,.cloud.bmw\" '$plist' 2>/dev/null || \
    /usr/libexec/PlistBuddy -c \"Set :EnvironmentVariables:\$var 127.0.0.1,localhost,.bmwgroup.net,.cloud.bmw\" '$plist'
  done
  
  /usr/libexec/PlistBuddy -c 'Print :EnvironmentVariables' '$plist'
  plutil -lint '$plist'
"
```

4) Reload/restart the daemon so it picks up the plist changes (single sudo session):

```sh
plist=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo sh -c "
  launchctl bootout system '$plist' 2>/dev/null || true
  launchctl bootstrap system '$plist'
  launchctl kickstart -k system/org.nixos.nix-daemon || true
"
```

### 3) Re-test cache reachability (forces substitution)

This disables local building so it *must* fetch from a substituter:

```sh
nix build nixpkgs#hello --no-link --option builders "" -L
```

Expected result:
- If the proxy is now effective for `nix-daemon`, it should download from `https://cache.nixos.org/` (and/or `cache.flakehub.com`) instead of timing out.
- The earlier `unknown setting 'http-proxy'` warnings should be gone.

### 4) If it still times out

Quick checks:

```sh
# Confirm daemon is the one running
ps aux | egrep 'nix-daemon' | grep -v egrep

# Confirm the launchd env is set (system domain)
sudo launchctl getenv HTTP_PROXY
sudo launchctl getenv HTTPS_PROXY
```

If those look correct but downloads still fail, the proxy may not allow CONNECT to `cache.nixos.org:443`, or `NO_PROXY` may be excluding the wrong domains.
