{ ... }:

{
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;

  # Выберите ровно тот display manager, который вы реально используете:
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Если используется GDM вместо greetd:
  # security.pam.services.gdm.enableGnomeKeyring = true;
  # security.pam.services.gdm-password.enableGnomeKeyring = true;

  # Если используется SDDM вместо greetd:
  # security.pam.services.sddm.enableGnomeKeyring = true;

  # Если используется LightDM вместо greetd:
  # security.pam.services.lightdm.enableGnomeKeyring = true;
}
