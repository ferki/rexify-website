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
   $url =~ s/^\///;

   my $page = DB::Model::Content->find($url);

   $self->render(page_content => $page->content);
}

1;
