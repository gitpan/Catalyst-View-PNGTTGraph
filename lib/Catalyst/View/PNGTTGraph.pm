package Catalyst::View::PNGTTGraph;

use strict;
use warnings;
use Image::LibRSVG;
use base qw(Catalyst::View::SVGTTGraph);

my($Revision) = '$Id: PNGTTGraph.pm,v 1.1.1.1 2006/02/11 17:54:15 terence Exp $';

our $VERSION = '0.02';

=head1 NAME

Catalyst::View::PNGTTGraph - PNG Graph View Component for Catalyst

=head1 SYNOPSIS

in your View.

  package MyApp::View::PNGTTGraph;
  use base 'Catalyst::View::PNGTTGraph';

in your controller.

  sub pie_graph : Local {
      my @fields = qw(Jan Feb Mar);
      my @data_sales_02 = qw(12 45 21);

      $c->svgttg->create('Pie',
                         {'height' => '500',
                          'width' => '300',
                          'fields' => \@fields,
                         });
      $c->svgttg->graph_obj->add_data({
                                       'data' => \@data_sales_02,
                                       'title' => 'Sales 2002',
                                      });
  }

  sub end : Private {
      my ( $self, $c ) = @_;
      $c->forward($c->view('PNGTTGraph'));
  }

and see L<SVG::TT::Graph>.

=head1 DESCRIPTION

Catalyst::View::PNGTTGraph is Catalyst PNG view handler of SVG::TT::Graph.

=cut

=head1 METHODS

=head2 new

this method makes method named $c->svgttg.
$c->svgttg is an accessor to the object of Catalyst::View::SVGTTGraphObj.
$c->svgttg uses $c->stash->{'Catalyst::View::SVGTTGraph'}.

=cut

#my $rsvg;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    my $rsvg = new Image::LibRSVG();
    $self->{rsvg} = $rsvg;
    return $self;
}

=head2 process

create PNG Graph

=cut

sub process {
    my $self = shift;
    my $c = shift;
    
    die "Catalyst::View::PNGTTGraph : graph object is undefined !"
        unless($c->svgttg->graph_obj);
#    $c->log->debug(Dumper($c->view_svggraph));

    my $svg_graph = $c->svgttg->burn;

    my $rsvg = $self->{rsvg};
    $rsvg->loadImageFromString($svg_graph);
    my $png_graph = $rsvg->getImageBitmap('png');

    $c->res->header('Content-Type' => 'image/png');
    $c->res->body($png_graph);
    return 1;
}

=head1 SEE ALSO

L<Catalyst::View::SVGTTGraph>, L<SVG::TT::Graph>

=head1 AUTHORS

Terence Monteiro <terence@deeproot.co.in>

=head1 COPYRIGHT AND LICENSE

Copyright (c) by DeepRoot Linux Pvt Ltd. L<http://deeproot.co.in>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

1;
