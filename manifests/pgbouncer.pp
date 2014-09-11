class pgbouncer(
    $listen_port = 6342,
    $default_pool_size,
    $query_wait_timeout = 60,
    $db_user,
    $db_password
  ) {
  package { 'pgbouncer': ensure => present }

  service { 'pgbouncer':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['pgbouncer'],
      File['pgbouncer.ini'],
      File['userlist.txt'],
      File['/etc/default/pgbouncer']
    ]
  }

  file { 'pgbouncer.ini':
    path    => '/etc/pgbouncer/pgbouncer.ini',
    ensure  => file,
    content => template('pgbouncer/pgbouncer.ini.erb'),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '640',
    require => Package['pgbouncer'],
    notify  => Service['pgbouncer']
  }

  file { 'userlist.txt':
    path    => '/etc/pgbouncer/userlist.txt',
    ensure  => file,
    content => template('pgbouncer/userlist.txt.erb'),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '640',
    require => Package['pgbouncer'],
    notify  => Service['pgbouncer']
  }

  file { '/etc/default/pgbouncer':
    ensure  => file,
    source  => 'puppet:///modules/pgbouncer/pgbouncer',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => Package['pgbouncer'],
    notify  => Service['pgbouncer']
  }
}
