{ ... }:

{
  xdg.mime = {
    enable = true;

    defaultApplications = {
      "inode/directory" = [
        "org.gnome.Nautilus.desktop"
      ];
    };
  };
}