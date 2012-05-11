package WebApp::Content;
use Mojo::Base 'Mojolicious::Controller';

sub index {
   my $self = shift;
   $self->render;
}

sub serve {
   my $self = shift;

   my $url = $self->tx->req->url->to_string;
   if($url !~ m/\.html$/) { $url .= "/index.html"; }

   my $file_content = "";
   open(my $fh, "<:encoding(UTF-8)", "content$url") or die($! . "content$url");
   my @c = <$fh>;
   close($fh);
   chomp @c;

   $file_content = join("\n", @c);

   $self->render(page_content => $file_content);
}

1;
