define diaspora::service( $command, $enabled = true ) {

  debug( "Install ${name}: ${enabled}" )
  
  runit::service { "diaspora_${name}":
    user    => diaspora,
    group   => diaspora,
    content => template('diaspora/run.erb'),
    logger  => false,
    ensure  => $enabled ? {
      true    => present,
      default => absent,
    },
  }

}
