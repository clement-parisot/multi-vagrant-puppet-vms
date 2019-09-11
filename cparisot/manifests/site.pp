node /.*\.(example.com)$/ {
  $ipaddress = $::networking['ip']

  hiera_include('classes')
}
