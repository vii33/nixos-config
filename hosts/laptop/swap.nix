{
  # On-disk swap big enough for hibernation + 25% extra
  swapDevices = [
    { device = "/swapfile"; size = 12288; }  # 12 GB swapfile
  ];

  # Tell systemd+kernel where to resume, UUID: *underlying partition* that holds the swapfile
  boot.resumeDevice = "/dev/disk/by-uuid/89a00461-4909-46da-ae07-1e17e5032e2b";

  # Compressed RAM for compensating spikes in memory usage
  zramSwap = {
    enable = true;
    memoryPercent = 20;   # ~2 GB fast compressed swap
    algorithm = "zstd";
    priority = 100;
  };

  boot.kernel.sysctl."vm.swappiness" = 20;  # default is 60, lower means less swap
}
