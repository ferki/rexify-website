package WebApp::Content;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub index {
   my $self = shift;
   $self->render;
}

sub serve {
   my $self = shift;

   my $url = $self->tx->req->url->to_string;
   if($url !~ m/\.html$/) { $url .= "/index.html"; }
   $url =~ s/^\/\//\//;

   my $page = DB::Model::Content->find($url);

   my $formular = $self->_get_rnd_number() . $self->_get_calc_method() . $self->_get_rnd_number();
   my $answer = eval($formular);

   $self->session("captcha_answer", $answer);

   $self->render(page_content => $page->content,
                  captcha => $formular);
}

sub _get_rnd_number {
   my ($self) = @_;

   my @numbers = qw/1 2 3 4 5 6 7 8 9 0/;

   return $numbers[int(rand(scalar(@numbers)))];
}

sub _get_calc_method {
   my ($self) = @_;

   my @meths = ("+", "-");

   return $meths[int(rand(scalar(@meths)))];
}

1;
