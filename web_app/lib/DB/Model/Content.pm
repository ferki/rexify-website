#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package DB::Model::Content;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('path', 'String');
__PACKAGE__->attr('title', 'String');
__PACKAGE__->attr('keywords', 'String');
__PACKAGE__->attr('desc', 'String');
__PACKAGE__->attr('content', 'Text');

__PACKAGE__->table('content');
__PACKAGE__->primary_key('path');

