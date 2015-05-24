exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
  user => 'root'
}->
class{'fc_base::setup':}