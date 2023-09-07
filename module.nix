{ config, lib, pkgs, ... }: {
  services = {
    getty.autologinUser = "root";
    nginx = {
      enable = true;
      virtualHosts.localhost.locations."/" = {
        index = "index.html";
        root = pkgs.writeTextDir "index.html" ''
                   <html>
                   <body>
                   This server's firewall has the following open ports:
          <ul>
          ${let
            renderPort = port: ''
              <li>${toString port}</li>
            '';

          in lib.concatMapStrings renderPort
          config.networking.firewall.allowedTCPPorts}
                   </ul>
                   </body>
                   </html>
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
  virtualisation.forwardPorts = [{
    from = "host";
    guest.port = 80;
    host.port = 8080;
  }];
  system.stateVersion = "22.11";
}
