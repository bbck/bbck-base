# Class: base::local_users
#
#
class base::local_users {
  $users = hiera('users')
  create_resources('local_user', $users)

  define local_user (
    $ensure  = 'present',
    $comment = 'Pupper managed user',
    $uid     = undef,
    $gid     = undef,
    $shell   = '/bin/bash',
    $ssh_key = undef,
  ) {
    validate_string($title)
    validate_string($comment)
    validate_re($uid, '')
    validate_re($gid, '')
    validate_re($shell, '^/.*/.*')
    validate_string($ssh_key)

    user { $title:
      ensure     => $ensure,
      gid        => $gid,
      managehome => true,
      shell      => $shell,
      uid        => $uid,
    }

    if $ssh_key {
      file { "/home/${name}/.ssh":
        ensure => directory,
        mode   => 0700,
        owner  => $name,
        group  => $name,
      }

      ssh_authorized_key { "${name}_key":
        key     => $ssh_key,
        type    => 'ssh-rsa',
        user    => $name,
        require => File["/home/${name}/.ssh"],
      }
    }
  }
}
