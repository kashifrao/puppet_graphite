
class project::graphite (
 
)



   {

require pkg::python::pip

package { 'graphite-web':       
ensure => $ensure,  
}

package { 'python-carbon':       
ensure => $ensure,  
}

package { 'python-whisper':       
ensure => $ensure,  
}

  
class { '::apache':
    default_vhost => false, 
  }

  

file { '/etc/httpd/conf.d/graphite.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('bundle/project/graphite/vhost_graphite.erb'),
  }

  
    package { 'python-beautifulsoup4':      
        ensure => $ensure,      
 
        }
        
     
   # ----------------------------------------------------------------------------
# mysql server setup

#allow mysql to listen every ip address  
   $override_options = {
  'mysqldump' => {
    'password'=> [hiera('project::graphite::backup_pass')],
  },
   'mysqld' => {
    'bind-address' => [''],
    'datadir' => '/local/mysql',
  }
}

 

#initiating mysql server
  class { '::mysql::server':
  root_password           => hiera('project::graphite::root_pass'),
  remove_default_accounts => true,
  override_options        => $override_options
}

  # create general mysql user for backups, phpmyadmin and other
mysql::db { 'mysql':
  user     => 'master',
  password => hiera('project::graphite::master_pass'),
  host     => '%',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
}

# ----------------------------------------------------------------------------
#mysql user creation and restoring mysql dump from /srv/shared
#create dctcms database and user

mysql::db { 'graphite':
  user     => 'graphite',
  password => hiera('project::graphite::db_pass'),
  host     => '%',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
}

  
 
# assign privileges to master
mysql_grant { 'graphite@%/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
   table      => '*.*',
  user       => 'graphite@%',
}
 
 

# ----------------------------------------------------------------------------
# Add any additional settings *above* this comment block.
# ----------------------------------------------------------------------------

   
}



