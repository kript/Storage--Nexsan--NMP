#!/software/bin/perl-5.12.2 -w 
# template script to run on linux/cluster machines with embedded documentation and command parsing
# script that runs an firmware upgrade of a nexsan, without restarting

use strict;
use v5.12.2; #make use of the say command and other nifty perl 10.0 onwards goodness
use Carp;
use File::Basename;

use FindBin qw($Bin);
use lib "$Bin/Storage-Nexsan-NMP/lib/";

use Storage::Nexsan::NMP;

#set the version number in a way Getopt::Euclid can parse
BEGIN { use version; our $VERSION = qv('0.1.1_1') }

use Getopt::Euclid; # Create a command-line parser that implements the POD below... 

my $nexsan = $ARGV{-n};
my $port = $ARGV{-p};
my $username = $ARGV{-u};
my $password = $ARGV{-P};



say "Connecting to Nexsan: $nexsan, Port: $port";           
my %NexsanInfo = ConnectToNexsan ($nexsan, $port);

my $sock = $NexsanInfo{sock};

#say "Nexsan Version: " . $NexsanInfo{NMP}{Major} . "." . $NexsanInfo{NMP}{Minor} . "." . $NexsanInfo{NMP}{Patch};
#say "Nexsan Serial: " . $NexsanInfo{serial};

#fill in the user and password details, then authenticate
$NexsanInfo{username} = $username;
$NexsanInfo{password} = $password;

AuthenticateNexsan (\%NexsanInfo);

#GetEventCount(\%NexsanInfo); 
##this will now be populated
#say "No Of Events: $NexsanInfo{eventCount}";

ShowSystemNexsan(\%NexsanInfo); 

say "Status: $NexsanInfo{status} Serial: $NexsanInfo{serial} model: $NexsanInfo{model}";
say "firmware: $NexsanInfo{firmware} friendlyname $NexsanInfo{friendlyname}"; 
say "vendor: $NexsanInfo{vendor} productid 	$NexsanInfo{productid} enclosurenaaid: $NexsanInfo{enclosurenaaid}";


close($sock);


__END__
=head1 NAME

Query-Nexsan - script to get usefull data from a Nexsan storage unit via thier NMP.




=head1 USAGE

    Query-Nexsan  [options] 

=head1 OPTIONS

=over

=item  -n[exsan] [=] <nexsan>

Specify Nexsan to connect to 


=for Euclid:
    nexsan.type:    string 

=item  -p[ort] [=] <port>

Specify port number to connect to NMP on, [default: port.default]

=for Euclid:
    port.type:    integer > 0
    port.type.error: must be a number above zero
    port.default:	44844

=item  -u[sername] [=] <username>

Specify username to connect with NMP, [default: username.default]

=for Euclid:
    username.type:    string
    username.type.error: must be a string
    username.default:	'ADMIN'
    
=item  -P[assword] [=] <password>

Specify password to connect with NMP, [default: password.default]

=for Euclid:
    password.type:    string
    password.type.error: must be a string
    password.default:	'password'
    
    
        

=item –v

=item --verbose

Print all warnings

=item --version

=item --usage

=item --help

=item --man

Print the usual program information

=back

=begin remainder of documentation here. . .

