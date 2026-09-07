{ pkgs, ... }:

let
  zapret2 = pkgs.stdenv.mkDerivation rec {
    pname = "zapret2";
    version = "1.0.5";

    src = pkgs.fetchurl {
      url =
        "https://github.com/bol-van/zapret2/releases/download/v${version}/zapret2-v${version}.tar.gz";

      hash = "sha256-t0P+mQxVy9SKLKBAgy0uyK4giE9B11AnQ+Vk5VGmh9M=";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      zlib
      libcap
      libnetfilter_queue
      libnfnetlink
      libmnl
      luajit
    ];

    preBuild = ''
      export PKG_CONFIG_PATH="${
        pkgs.lib.makeSearchPath "lib/pkgconfig" [
          pkgs.libnetfilter_queue
          pkgs.libnfnetlink
          pkgs.libmnl
          pkgs.luajit
        ]
      }"

      export LUA_CFLAGS="-I${pkgs.luajit}/include/luajit-2.1"
      export LUA_LIB="-L${pkgs.luajit}/lib -lluajit-5.1"

      export CFLAGS="$CFLAGS \
        -I${pkgs.libnetfilter_queue}/include \
        -I${pkgs.libnfnetlink}/include \
        -I${pkgs.libmnl}/include"

      export LDFLAGS="$LDFLAGS \
        -L${pkgs.libnetfilter_queue}/lib \
        -L${pkgs.libnfnetlink}/lib \
        -L${pkgs.libmnl}/lib"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/libexec/zapret2" "$out/bin"

      cp -a ./. "$out/libexec/zapret2/"

      chmod +x \
        "$out/libexec/zapret2/init.d/systemd/zapret2.sh" \
        "$out/libexec/zapret2/init.d/systemd/zapret2-list-update.sh"

      install -Dm755 \
        "$out/libexec/zapret2/init.d/systemd/zapret2.sh" \
        "$out/bin/zapret2"

      install -Dm755 \
        "$out/libexec/zapret2/init.d/systemd/zapret2-list-update.sh" \
        "$out/bin/zapret2-list-update"

      runHook postInstall
    '';

    meta = {
      description = "Anti-DPI software";
      homepage = "https://github.com/bol-van/zapret2";
      platforms = pkgs.lib.platforms.linux;
    };
  };

  zapretStateDir = "/var/lib/zapret2";
in
{
  environment.systemPackages = [
    zapret2
    pkgs.nftables
    pkgs.iproute2
    pkgs.procps
  ];

  systemd.tmpfiles.rules = [
    "d ${zapretStateDir} 0755 root root -"
  ];

  systemd.services.zapret2 = {
    description = "zapret2 anti-DPI service";

    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];

    after = [
      "network-online.target"
      "nftables.service"
    ];

    path = with pkgs; [
      bash
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      iproute2
      iptables
      nftables
      procps
      which
      zapret2
    ];

    serviceConfig = {
      Type = "forking";
      User = "root";
      Group = "root";
      Restart = "on-failure";
      RestartSec = 5;

      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
      ];

      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
      ];
    };

    script = ''
      export ZAPRET_BASE=${zapret2}/libexec/zapret2
      export ZAPRET_DIR=${zapretStateDir}

      exec ${pkgs.bash}/bin/bash \
        ${zapret2}/libexec/zapret2/init.d/systemd/zapret2.sh start
    '';

    preStop = ''
      export ZAPRET_BASE=${zapret2}/libexec/zapret2
      export ZAPRET_DIR=${zapretStateDir}

      ${pkgs.bash}/bin/bash \
        ${zapret2}/libexec/zapret2/init.d/systemd/zapret2.sh stop
    '';
  };

  systemd.services.zapret2-list-update = {
    description = "Update zapret2 hostlists";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = with pkgs; [
      bash
      coreutils
      curl
      gawk
      gnugrep
      gnused
      iproute2
      nftables
      zapret2
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
    };

    script = ''
      export ZAPRET_BASE=${zapret2}/libexec/zapret2
      export ZAPRET_DIR=${zapretStateDir}

      exec ${pkgs.bash}/bin/bash \
        ${zapret2}/libexec/zapret2/init.d/systemd/zapret2-list-update.sh
    '';
  };

  systemd.timers.zapret2-list-update = {
    description = "Randomized zapret2 list update every two days";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      OnUnitActiveSec = "2d";
      RandomizedDelaySec = "1d";
      Persistent = true;
      Unit = "zapret2-list-update.service";
    };
  };
}
