class tilde::webserver ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"

  file { ['/var/www', $www_root]:
    ensure => directory,
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    use_default_location => false,
    server_name => ["www.${hostname}", $hostname],
  }

  nginx::resource::location { 'main':
    ensure => present,
    vhost => $hostname,
    location => '/',
    www_root => $www_root,
  }

  nginx::resource::location { 'userContent':
    ensure => present,
    location => '~ "^/~(.+?)(/.*)?$"',
    vhost => $hostname,
    location_alias => '/home/$1/public_html$2',
  }
}
