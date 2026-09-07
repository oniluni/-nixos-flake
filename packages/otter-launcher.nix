{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "otter-launcher";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "kuokuo123";
    repo = "otter-launcher";
    rev = "main";
    hash = "sha256-/1dN67dKM0CGRgtq0n1k/SDDB4Agaf10eFSohzY8teE";
  };

  cargoHash = "sha256-WTjVDkExigSqV/u5GdjrkQOu2KH/eWTp7eCHIINDX50";

  meta = {
    description = "Hackable CLI/TUI launcher";
    homepage = "https://github.com/kuokuo123/otter-launcher";
    license = lib.licenses.gpl3Only;
    mainProgram = "otter-launcher";
    platforms = lib.platforms.linux;
  };
}
