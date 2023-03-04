let
  key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFzXIO+8lGsvov8zkSXQSIr5io+UyLvfhvou6dte/CA";
in
{
  "wg-desktop.age".publicKeys = [ key1 ];
  "wg-laptop.age".publicKeys = [ key1 ];
}
