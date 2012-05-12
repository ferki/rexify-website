package WebApp;
use Mojo::Base 'Mojolicious';

use DM4P;
use DM4P::Connection::Server::MySQL;
use DM4P::DM;

use DB::Model::Content;

# This method will run once at server start
sub startup {
   my $self = shift;

   # Documentation browser under "/perldoc"
   $self->plugin('PODRenderer');
   my $config = $self->plugin("Config");

   $self->helper(keywords => sub { return ""; });

   # Router
   my $r = $self->routes;

   # Normal route to controller
   $r->route('/')->to('content#index');

   $r->route('/*')->to('content#serve');

   # initialize database
   DM4P::setup(default => "MySQL://" 
                        . $config->{"db"}->{"server"}
                        . "/"
                        . $config->{"db"}->{"schema"}
                        . "?username="
                        . $config->{"db"}->{"user"}
                        . "&password="
                        . $config->{"db"}->{"password"}
                        . "&characterEncoding=UTF-8"
                        );

   eval {
      my $db = DM4P::get_connection("default");
      $db->connect;

      DB::Model::Content->set_data_source($db);
   };

   if($@) {
      die("Can't connect to database. ($@)");
   }
}

1;
