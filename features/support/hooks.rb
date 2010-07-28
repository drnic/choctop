After("@unmount_dmg") do
  # unmount the disk image for scenarios tagged "@unmount_dmg"
  system "/sbin/umount #{@volume_path}"
end