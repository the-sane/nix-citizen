{ stdenv, lib, pins, makeDesktopItem, makeWrapper, copyDesktopItems, bash, coreutils
, findutils, gnome, zenity ? gnome.zenity, symlinkJoin, pkgs, }:
let
  inherit (pins) lug-helper;
  version = "2.14";
  src = pkgs.fetchFromGitHub {
    owner = "starcitizen-lug";
    repo = "lug-helper";
    rev = "v${version}";
    hash = "sha256-Pgak1CcmdAWL3xRrEwafCkAl+nZNGI5ewvIXMtyPp8k=";
  };
in stdenv.mkDerivation rec {
  name = "lug-helper";
  inherit (lug-helper) version;
  src = lug-helper;

  buildInputs = [ bash coreutils findutils zenity ];
  nativeBuildInputs = [ copyDesktopItems makeWrapper ];
  desktopItems = [
    (makeDesktopItem {
      name = "lug-helper";
      exec = "lug-helper";
      icon = "${src}/lug-logo.png";
      comment = "Star Citizen LUG Helper";
      desktopName = "LUG Helper";
      categories = [ "Utility" ];
      mimeTypes = [ "application/x-lug-helper" ];
    })
  ];

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/lug-helper
    mkdir -p $out/share/pixmaps

    cp lug-helper.sh $out/bin/lug-helper
    cp -r lib/* $out/share/lug-helper/
    cp lug-logo.png $out/share/pixmaps/lug-helper.png
    wrapProgram $out/bin/lug-helper \
      --prefix PATH : ${lib.makeBinPath [ bash coreutils findutils zenity ]}

  '';
  meta = with lib; {
    description = "Star Citizen LUG Helper";
    homepage = "https://github.com/starcitizen-lug/lug-helper";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fuzen ];
    platforms = platforms.all;
  };
}
