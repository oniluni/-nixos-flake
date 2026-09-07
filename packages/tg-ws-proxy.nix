{ pkgs
, python3Packages
, fetchFromGitHub
, ...
}:

python3Packages.buildPythonApplication rec {
  pname = "tg-ws-proxy";
  version = "1.10.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Flowseal";
    repo = "tg-ws-proxy";
    rev = "v${version}";
    hash = "sha256-ZqOn4ya2jQwwJq4oCI6d0+y4fy1kO4dboWQTAowhuhc=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    customtkinter
    requests
    cryptography
    pillow
    psutil
    pyperclip
    pystray
  ];

  buildInputs = with pkgs; [
    libxcb
    libX11
    libappindicator-gtk3
    gtk3
  ];

  dontCheckRuntimeDeps = true;
  doCheck = false;
}