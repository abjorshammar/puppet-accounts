define accounts::users (
  $uid        = 'UNSET',
  $realname   = 'UNSET',
  $password   = '*',
  $shell      = '/bin/bash',
  $home_path  = '/home',
  $abshome    = 'UNSET',
  $managehome = true,
  $sshkeytype = 'rsa',
  $sshkey     = 'UNSET',
  $groups     = []
  ) {

  if $::osfamily == 'Debian' {
    ensure_packages(['libshadow-ruby1.8'])
  }

  if $abshome == 'UNSET' {
    $actual_home = "${home_path}/${title}"
  } else {
    $actual_home = $abshome
  }

  # Create the user
  user { $title:
    ensure            =>  'present',
    uid               =>  $uid,
    gid               =>  $title,
    password          =>  $password,
    shell             =>  $shell,
    home              =>  $actual_home,
    comment           =>  $realname,
    managehome        =>  $managehome,
    groups            =>  $groups,
    require           =>  Group[$title],
  }

  # Create a matching group
  group { $title:
    gid               => $uid,
  }

  if $managehome == true {

    # Ensure the home directory exists with the right permissions
    file { $actual_home:
      ensure            =>  directory,
      owner             =>  $title,
      group             =>  $title,
      mode              =>  '0750',
      require           =>  [ User[$title], Group[$title] ],
    }
      # Ensure the .ssh directory exists with the right permissions
      file { "${actual_home}/.ssh":
        ensure            =>  directory,
        owner             =>  $title,
        group             =>  $title,
        mode              =>  '0700',
        require           =>  File[$actual_home],
    }
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
