{ config, pkgs, lib, ... }:

let
  resolvepatched = pkgs.davinci-resolve-studio.override (old: {
    buildFHSEnv =
      fhs:
      (
        let
          # This is the actual DaVinci binary, we can run perl here
          davinci = fhs.passthru.davinci.overrideAttrs (old: {
            postFixup = ''
              ${old.postFixup}
              ${pkgs.perl}/bin/perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/' $out/bin/resolve
              ${pkgs.perl}/bin/perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/' $out/bin/resolve
              ${pkgs.perl}/bin/perl -pi -e 's/\x41\xb6\x01\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/\x41\xb6\x00\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/' $out/bin/resolve
              echo -e "LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted\n  hostid=ANY issuer=CGP customer=CGP issued=28-dec-2023\n  akey=0000-0000-0000-0000 _ck=00 sig=\"00\"" | tee $out/.license/blackmagic.lic
            '';
          });
          studioVariant = true;
        in
        # This part overrides the wrapper, we need to replace all of the instances of ${davinci} with the patched version
        # Copies the parts from the official nixpkgs derivation that need overriding
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/da/davinci-resolve/package.nix
        old.buildFHSEnv (
          fhs
          // {
            extraPreBwrapCmds = lib.optionalString studioVariant ''
              mkdir -p ~/.local/share/DaVinciResolve/Extras || exit 1
            '';
            extraBwrapArgs = lib.optionals studioVariant [
              ''--bind "$HOME"/.local/share/DaVinciResolve/Extras ${davinci}/Extras''
              ''--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL''
            ];
            runScript = "${pkgs.bash}/bin/bash ${pkgs.writeText "davinci-wrapper" ''
              export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
              export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
              unset QT_QPA_PLATFORM
              ${davinci}/bin/resolve
            ''}";
            extraInstallCommands = ''
              mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
              ln -s ${davinci}/share/applications/*.desktop $out/share/applications/
              ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve${lib.optionalString studioVariant "-studio"}.png
            '';
            passthru = { inherit davinci; };
          }
        )
      );
  });
in 
{
  environment.systemPackages = with pkgs; [
    resolvepatched
  ];
}
