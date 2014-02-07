define accounts::groups (
  $gid    = '',
  $ensure = 'present',
  ) {

  # Create the group
  group { $title:
    ensure  => $ensure,
    gid     => $uid,
  }