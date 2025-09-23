{
  # On-disk swap big enough for hibernation + 25% extra to avoid out of memory issues
  # swap file first needs to be create manually
  # then offset needs to be set with `filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }'`
  # then hibernate needs to be used once with `sudo systemctl hibernate` -- after this it should
  # be visible in start menu
  swapDevices = [
    { 
      device = "/swapfile"; 
      size = 12*1024; 
      priority = 100;
    }  
  ];

  # Tell systemd+kernel where to resume, UUID: *underlying partition* that holds the swapfile
  boot.resumeDevice = "/dev/disk/by-uuid/89a00461-4909-46da-ae07-1e17e5032e2b";
  boot.kernelParams = ["resume_offset=18022400" ];  # change offset to the one you got from filefrag

  # Compressed RAM for compensating spikes in memory usage
  zramSwap = {
    enable = true;
    memoryPercent = 15;   # ~1 GB fast compressed swap
    algorithm = "zstd";
    priority = 10;
  };

  boot.kernel.sysctl."vm.swappiness" = 20;  # default is 60, lower means less swap
}
