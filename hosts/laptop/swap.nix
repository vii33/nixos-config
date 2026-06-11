{
  # Compressed RAM for short memory pressure spikes.
  # Disk swap is still declared in hardware-configuration.nix and remains
  # available for hibernation/resume and as a fallback.
  zramSwap = {
    enable = true;
    memoryPercent = 15;
    algorithm = "zstd";
    priority = 70;
  };

  boot.kernel.sysctl."vm.swappiness" = 40;
}
