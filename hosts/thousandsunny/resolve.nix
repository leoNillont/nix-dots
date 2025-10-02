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
              ${pkgs.perl}/bin/perl -pi -e 's/\x74\x11\xe8\x21\x23\x00\x00/\xeb\x11\xe8\x21\x23\x00\x00/g' $out/bin/resolve
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
            extraBwrapArgs = lib.optionals studioVariant [
              "--bind \"$HOME\"/.local/share/DaVinciResolve/license ${davinci}/.license"
            ];
            runScript = "${pkgs.bash}/bin/bash ${pkgs.writeText "davinci-wrapper" ''
              export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
              export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
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


