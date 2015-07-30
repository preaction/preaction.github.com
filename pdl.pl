
use strict;
use warnings;
use feature qw( :5.20 );

use PDL;
use PDL::Finance::TA;

# Create a random time series of 500,000 elements
# from 0 to 50
#my $ts = random( 1_000_000 ) * 5000;
my $ts = random( 100 ) * 10;
$ts = $ts->append( 30 ); # Outlier
$ts = $ts->append( random( 100 ) * 10 );
say $ts->slice( "98:102" );

# Calculate the single-day momentum (change)
my $roc = ta_mom( $ts, 1 );
say $roc->slice( "98:102" );

# Calculate the 30-day stddev of the momentum
my $stddev = ta_stddev( $roc, 30, 1 );
say $stddev->slice( "98:102" );

# Find which points whose momentum is more than 4 stddev
# from the mean
my $outlier = which( $roc->abs > $stddev * 4 );
say "Outliers: " . $outlier->getdim(0);

say $ts->slice( $outlier->slice( "0:0" ) );
