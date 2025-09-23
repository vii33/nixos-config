# nbfc.nix
# GUIDE
# 1. Adjust the myUser variable to your username
# 2. create file ~/.config/nbfc.json
# 3. sudo nano ~/.config/nbfc.json
# 4. {  "SelectedConfigId": "Xiaomi Mi Book (TM1613, TM1703)",
#       "TargetFanSpeeds": [ 40.000000, 40.000000 ]
#    }

{ config, inputs, pkgs, ...}: 

let
  myUser = "vii";   #adjust this to your username
  command = "bin/nbfc_service --config-file '/home/${myUser}/.config/nbfc.json'";

in 
{
  environment.systemPackages = with pkgs; [
    # if you are on stable uncomment the next line
    #nbfc-linux.packages.x86_64-linux.default
    # if you are on unstable uncomment the next line
    nbfc-linux
  ];
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type = "simple";
    path = [pkgs.kmod];

    # if you are on stable uncomment the next line
    #script = "${nbfc-linux.packages.x86_64-linux.default}/${command}";
    # if you are on unstable uncomment the next line
    script = "${pkgs.nbfc-linux}/${command}";
   
    wantedBy = ["multi-user.target"];
  };
}