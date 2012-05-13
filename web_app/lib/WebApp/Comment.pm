package WebApp::Comment;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub create {
   my $self = shift;
   my $r = $self->tx->req;

   my $url = $self->tx->req->headers->header("referer");

   if($url !~ m/\.html$/) { $url .= "/index.html"; }
   $url =~ s/^\///;

   my $answer = $self->session("captcha_answer");

   if($r->param("question") eq $answer) {
      # db
   }
   else {
      $self->flash(message => "Please calculate.");
   }

   $self->redirect_to($url);
}

1;
