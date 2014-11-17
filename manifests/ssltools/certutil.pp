define certs::ssltools::certutil($cert_name=$title, $nss_db_dir, $client_cert, $refreshonly = true) {
  file { $client_cert:
    ensure => present
  } ->
  exec { "delete ${cert_name}":
    path => ['/bin', '/usr/bin'],
    unless => "certutil -D -d ${nss_db_dir} -n '$cert_name'",
    onlyif => "certutil -L -d ${nss_db_dir} | grep '$cert_name'",
    refreshonly => $refreshonly,
  } ->
  exec { $cert_name:
    path => ['/bin', '/usr/bin'],
    command => "certutil -A -d '${nss_db_dir}' -n '$cert_name' -t ',,' -a -i '${client_cert}'",
    unless => "certutil -L -d ${nss_db_dir} | grep '$cert_name'",
    refreshonly => $refreshonly,
  }
}
