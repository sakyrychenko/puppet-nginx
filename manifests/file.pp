# Define: nginx::file
#
# Manage NGINX configuration file snippets, installed from source or template.
# The main service is automatically notified when files are added, removed or
# modified.
#
# Parameters:
#  $content:
#    Content for the file, typically from a template. Default: none
#  $source:
#    Source for the file. Mutually exclusive with $content. Default: none
#
# Sample Usage :
#  nginx::file { 'example1.conf':
#    source => 'puppet:///files/nginx/example1.conf',
#  }
#  nginx::file { 'example2.conf':
#    content => template('mymodule/example2.conf.erb'),
#  }
#
define nginx::file (
  $ensure  = undef,
  $owner   = 'root',
  $group   = 'root',
  $mode    = '0644',
  $content = undef,
  $source  = undef,
  $confd   = true,
) {
  include '::nginx::params'
  $subdir = $confd ? {
    true  => '/conf.d',
    false => '',
  }
  file { "${::nginx::params::confdir}${subdir}/${title}":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    notify  => Service['nginx'],
    require => Package['nginx'],
  }
}

