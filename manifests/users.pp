define accounts::users (
  $uid        = 'UNSET',
  $realname   = 'UNSET',
  $shell      = '/bin/bash',
  $home_path  = '/home',
  $sshkeytype = 'rsa',
  $sshkey     = 'UNSET',
  $groups     = ''
  ) {

  # Create the user
  user { $title:
    ensure            =>  'present',
    uid               =>  $uid,
    gid               =>  $title,
    shell             =>  $shell,
    home              =>  "${home_path}/${title}",
    comment           =>  $realname,
    managehome        =>  true,
    groups            =>  $groups,
    require           =>  Group[$title],
  }

  # Create a matching group
  group { $title:
    gid               => $uid,
  }

  # Ensure the home directory exists with the right permissions
  file { "${home_path}/${title}":
    ensure            =>  directory,
    owner             =>  $title,
    group             =>  $title,
    mode              =>  '0750',
    require           =>  [ User[$title], Group[$title] ],
  }

  # Ensure the .ssh directory exists with the right permissions
  file { "${home_path}/${title}/.ssh":
    ensure            =>  directory,
    owner             =>  $title,
    group             =>  $title,
    mode              =>  '0700',
    require           =>  File["${home_path}/${title}"],
  }

  # Add user's SSH key
  if ($sshkey != 'UNSET') {
    ssh_authorized_key {$title:
      ensure          => present,
      name            => $title,
      user            => $title,
      type            => $sshkeytype,
      key             => $sshkey,
    }
  }
}
