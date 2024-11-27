# Example Puppet Manifest for installing Apache2 and PHP 
#
# This accomplishes this task:  sudo apt install apache2
#
# v1.0.0
#
# This manifest uses the "require" syntax, ensuring proper order:
# 1. Make sure the Apache2 package is installed
# 2. Copy a new version of mysql.cnf to the Apache2 configuration directory
# 3. Ensure the Apache2 service is running.
#
# "source" path for the mysql.cnf file below must be updated
# by the student to the patch appropriate for their system.

package { 'apache2':
  ensure => installed,
}

package { 'php':
  ensure => installed,
  notify  => Service['apache2'],
  require => [Package['apache2']],
}

package { 'libapache2-mod-php':
  ensure => installed,
  notify  => Service['apache2'],
  require => [Package['apache2']],
}

package { 'php-cli':
  ensure => installed,
  notify  => Service['apache2'],
  require => [Package['apache2']],
}

package { 'php-mysql':
  ensure => installed,
  notify  => Service['apache2'],
  require => [Package['apache2']]
}

file { '/var/www/html/phpinfo.php':
  source => '/home/jaxberg/inet4031-puppet-testing/files/phpinfo.php',
  notify  => Service['apache2'],
  require => [Package['apache2']]
}

package { 'mariadb-server':
  ensure => installed
}

service { 'apache2':
  ensure => running,
  enable => true,
  require => [Package['apache2'], Package['php'], Package['libapache2-mod-php'], Package['php-cli'], Package['php-mysql']]
}

service { 'mariadb':
  ensure => running,
  enable => true,
  require => [Package['mariadb-server']]
}

vcsrepo { '/home/jaxberg/employees':
  ensure => present,
  provider => git,
  source => {
    origin => 'https://github.com/datacharmer/test_db.git',
    github => 'https://github.com/datacharmer/test_db.git',
  }
}

vcsrepo { '/home/jaxberg/phpcrudecrud':
  ensure => present,
  provider => git,
  source => {
    origin => 'https://github.com/axbjos/inet4031-phpcrudecrud-lamp.git',
    github => 'https://github.com/axbjos/inet4031-phpcrudecrud-lamp.git',
  }
}
