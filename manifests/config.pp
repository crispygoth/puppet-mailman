define mailman::config(
  $variable,
  $value,
  $mlist,
  $ensure = present,
) {

  ensure_resource('concat', "/var/lib/mailman/lists/${mlist}/puppet-config.conf", {
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Exec["load configuration on ${mlist}"],
  })
  ensure_resource('exec', "load configuration on ${mlist}", {
    refreshonly => true,
    command     => "/usr/sbin/config_list -i /var/lib/mailman/lists/${mlist}/puppet-config.conf ${mlist}",
  })

  concat::fragment {$name:
    target  => "/var/lib/mailman/lists/${mlist}/puppet-config.conf",
    content => template('mailman/config_list.erb'),
    require => [Class['mailman'], Maillist[$mlist]],
  }
}
