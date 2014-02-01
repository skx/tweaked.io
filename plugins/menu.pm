#
# This is a templer-plugin.
#
# Steve
# --

use strict;
use warnings;


package Templer::Plugin::menu;

sub new
{
    my ( $proto, %supplied ) = (@_);
    my $class = ref($proto) || $proto;

    my $self = {};
    bless( $self, $class );
    return $self;
}


sub expand_variables
{
    my ( $self, $site, $page, $data ) = (@_);

    #
    #  Get the page-variables in the template.
    #
    my %hash = %$data;

    foreach my $key ( keys %hash )
    {
        my $value = $hash{ $key };

        #
        # Ignore non-menu keys in this plugin
        #
        next unless ( $key =~ /menu/i && $value =~ /menu/i );
        my $menu = undef;

        #
        # Find the location of our input-tree.
        #
        my $input = $data->{ "input" };

        #
        # Find all sections beneath /input/guide/
        #
        foreach my $section ( sort( glob( $input . "/guide/*/" ) ) )
        {

            #
            # Skip the general-page
            #
            next if ( $section =~ /general/i );

            #
            #  Get the path to the current page being processed.
            #
            #  (We want to set "id=current" on this page, to style it.)
            #
            my $pPath = $page->source();

            #
            #  Work out the short-name of this section.
            #
            $section =~ s/\/$//g;
            $section = File::Basename::basename($section);

            #
            #  Bold if this page is the current-page.
            #
            my $bold = undef;
            $bold = 1 if ( $pPath =~ /\/$section\// );

            #
            #  Save the page in the loop available to the layout.
            #
            push( @$menu,
                  {  name => $section,
                     path => "/guide/$section/",
                     bold => $bold
                  } );
        }

        #
        # Make the look-variable "primitives" available to the
        # page that invoked us.
        #
        $hash{ 'menu' } = undef;
        $hash{ 'menu' } = $menu if ($menu);

    }

    return ( \%hash );
}


#
#  Register the plugin.
#
Templer::Plugin::Factory->new()->register_plugin("Templer::Plugin::menu");
