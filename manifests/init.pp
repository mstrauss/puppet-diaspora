class diaspora( $rootdir, $url, $ensure = present,
  $websocket = true, $resque_web = true, $worker = true,
  $web = true, $web_port = 3000 ) {
  
  # this is just a dummy service which holds common environment variables for
  # all diaspora services
  runit::service { diaspora:
    user    => diaspora,
    group   => diaspora,
    content => 'false',   # as said before, just a dummy service
    ensure  => $ensure,
    enable  => false,     # this is just a dummy service to hold all our env. vars.
  }

  # the shared environment
  Runit::Service::Env { ensure => $ensure }
  runit::service::env { 'Diaspora_Root': value => $rootdir,   service => diaspora }
  runit::service::env { 'HOME':          value => $rootdir,   service => diaspora }
  runit::service::env { 'Diaspora_Url':  value => $url,       service => diaspora }
  runit::service::env { 'QUEUE':         value => '*',        service => diaspora }
  runit::service::env { 'RAILS_ENV':     value => production, service => diaspora }

  diaspora::service {
    websocket:  enabled => $websocket,  command => 'bundle exec ruby script/websocket_server.rb';
    resque_web: enabled => $resque_web, command => '/usr/bin/resque-web -F';
    worker:     enabled => $worker,     command => 'bundle exec rake resque:work';
    web:        enabled => $web,        command => "bundle exec rails s thin -p ${web_port}";
  }
}
