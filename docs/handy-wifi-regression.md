# Handy WiFi Regression

read_when: changing global hotkeys, input groups, `keyd`, or Handy integration.

Handy's Linux `handy_keys` backend uses raw `rdev` input grabs. On the ThinkPad
X1 Carbon 7th it conflicted with `keyd` and caused a WLAN soft rfkill block
shortly after login. Do not add Handy, its `handy_keys` backend, `/dev/uinput`,
or Handy-specific `input`-group access back to the laptop configuration.

When diagnosing a similar failure, confirm with `rfkill` and stop Handy with:

```bash
systemctl --user stop handy.service
```
