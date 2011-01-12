#!/usr/bin/perl
# ArchTrack AUR slurpie v0.1 (atslurpie.pl)
# copyleft - fnord0@riseup.net

use WWW::Mechanize;
use HTML::TokeParser;
use HTML::TreeBuilder;
use Getopt::Std;
use Term::ANSIColor qw(:constants);
$Getopt::Std::STANDARD_HELP_VERSION = 1;

getopts ('nsf:');
if ($opt_f) {
	$infile = $opt_f;
  	open (LIST,"$infile") or die BOLD, BLUE, "[" . BOLD, RED "!", BOLD, BLUE, . "]", RESET . " could not open file " . BOLD, BLUE, "$infile", RESET;
        my(@lines) = <LIST>;
        if ($opt_s) {
		@lines = sort(@lines);
	}
        ($line);
	foreach $line (@lines) {
       		&DOITNOW;
	}
       	close(LIST);
} elsif (!@ARGV) {
	die BOLD, BLUE, "[" . BOLD, RED "!", BOLD, BLUE, . "]", RESET . " you must submit a search request, look at '" . BOLD, BLUE, "--help", RESET . "' for more info\n";
} else {
	&DOITNOW;
}

sub DOITNOW {
my $url = 'https://aur.archlinux.org/?detail=1';
my $writefile = '/tmp/aur.html';
my $mech = WWW::Mechanize->new();
   $mech->cookie_jar(HTTP::Cookies->new( ));
   $mech->get($url);
   if ($opt_f and  $opt_n = 1) {
   $mech->submit_form(
        form_number => 2,
        fields      => {
   		        K    => $line,
			PP   => '100', #100 results per page
			SeB  => 'n',   #search name field only
	}
    );
   } elsif ($opt_n) {
   $mech->submit_form(
        form_number => 2,
        fields      => {
                        K    => @ARGV,
                        PP   => '100', #100 results per page
                        SeB  => 'n',   #search name field only
                       }
    );
   } else {
      $mech->submit_form(
        form_number => 2,
        fields      => {
                        #K    => $ARGV[0],
                        K    => @ARGV,
                        PP   => '100', #100 results per page
                       }
    );
}

$mech->success or die "Search failed!\n";

my $stream = HTML::TokeParser->new(\$mech->{content});
	#  <td class='data1'><span class='f5'><span class='blue'>unsupported</span></span></td>
	#  <td class='data1'><span class='f5'><span class='blue'>system</span></span></td>
	while (my $test = $stream->get_tag('td', 'td')) {
			#  <td class='data1'><span class='f4'><a href='packages.php?ID=30362'><span class='black'>ewallset-svn 3-1</span></a></span></td>
		my $tag = $stream->get_tag("td");
		if ($tag->[1]{class} and $tag->[1]{class} =~ 'data\d') {
			$stream->get_tag("span");
			my $aurid = $stream->get_tag("a");
			my $aururl = $aurid->[1]{href};
				if ($aururl =~ s/packages\.php\?ID=(\d+)/$1/g) {
					print "\n";
					print BOLD, BLUE, "AUR ID: ", RESET . "$aururl\n";
				} else {
					$aururl = undef;
				}
			$aurpkg = $stream->get_text("/a");
				if ($aurpkg =~ /\s+/) {
					@aurtool = split(/\s/, $aurpkg);
	   				print BOLD, BLUE, "AUR PKGNAME: ", RESET . "$aurtool[0]\n";
	   				print BOLD, BLUE, "AUR PKGVER: ", RESET . "$aurtool[1]\n";
				} elsif ($aurpkg !~ /\s/) {
					print BOLD, BLUE, "AUR maintainer: ", RESET . "$aurpkg\n";	
				}
		}

		if ($tag->[1]{class} and $tag->[1]{class} =~ 'outofdate') {
                        $stream->get_tag("span");
                        my $auroutid = $stream->get_tag("a");
                        my $aurouturl = $auroutid->[1]{href};
                                if ($aurouturl =~ s/packages\.php\?ID=(\d+)/$1/g) {
                                        print "\n";
                                        print BOLD, RED, "OUTOFDATE :: AUR ID: ", RESET . "$aurouturl\n";
                                } else {
                                        $aurouturl = undef;
                                }
                        $auroutpkg = $stream->get_text("/a");
                                if ($auroutpkg =~ /\s+/) {
                                        @aurouttool = split(/\s/, $auroutpkg);
                                        print BOLD, RED, "OUTOFDATE :: AUR PKGNAME: ", RESET . "$aurouttool[0]\n";
                                        print BOLD, RED, "OUTOFDATE :: AUR PKGVER: ", RESET . "$aurouttool[1]\n";
                                } elsif ($auroutpkg !~ /\s/) {
                                        print BOLD, RED, "OUTOFDATE :: AUR maintainer: ", RESET . "$auroutpkg\n";
                                }
                }
           $stream->get_tag("td");
           $stream->get_tag("td");
        my $scatter =  $stream->get_tag("span");
        if ($scatter->[1]{class} and $scatter->[1]{class} eq 'f4') {
                my $tidbit = $stream->get_text("/span");
				$tidbit =~ s/\n./$1/g;
                                print BOLD, BLUE, "AUR Description: ", RESET . "$tidbit\n";
	}

}

   $streamyy = HTML::TokeParser->new(\$mech->{content});
   $streamyy->get_tag("div");
   $streamyy->get_tag("form");
   $streamyy->get_tag("div");
   $streamyy->get_tag("span");
   $streamyy->get_tag("input");
   $streamyy->get_tag("input");
   $streamyy->get_tag("input");
my $auridzzi = $streamyy->get_tag("a");
   $aururlzzi = $auridzzi->[1]{href};
	if ($aururlzzi =~ s/\?ID=(\d+)/$1/g) {
        	print "\n";
        	print BOLD, BLUE, "AUR ID#: ", RESET . "$1\n";
		&ROOKIE;
        } else {
		#print "\npeace out, we be done";
	}
}
sub ROOKIE {

while (my $testnew = $streamyy->get_tag('div', 'div')) {
	my $gulag = $streamyy->get_tag("span");
        if ($gulag->[1]{class} and $gulag->[1]{class} eq 'f2') {
                my $resultzz = $streamyy->get_text("/span");
			if ($resultzz =~ /\s+/) {
                		@aursingled = split(/\s/, $resultzz);
                		print BOLD, BLUE, "AUR PKGNAME: ", RESET . "$aursingled[0]\n";
                		print BOLD, BLUE, "AUR PKGVER: ", RESET . "$aursingled[1]\n";
        		}
	&DOOKIE;
	#print "============================\n";
	}
}
}

sub DOOKIE {
	   $streamyy->get_tag("span");
	my $trampled =  $streamyy->get_tag("span");
	if ($trampled->[1]{class} and $trampled->[1]{class} eq 'f3') {
                my $resultzzing = $streamyy->get_text("/span");
                        if ($resultzzing =~ /\s+/) {
				print BOLD, BLUE, "AUR Description: ", RESET . "$resultzzing\n";
           $streamyy->get_tag("span");
           $streamyy->get_tag("span");
           $streamyy->get_tag("span");
           $streamyy->get_tag("span");
           $streamyy->get_tag("span");
           $streamyy->get_tag("span");
        my $rookout =  $streamyy->get_tag("span");
        if ($rookout->[1]{class} and $rookout->[1]{class} eq 'f6') {
				print BOLD, RED, ".::[OUT OF DATE]::.\n", RESET;
				}
                        }
	}
}

sub VERSION_MESSAGE { my $fh = shift;
		      print $fh ".::[" . BOLD, RED " ArchTrack AUR slurpie v0.1 " . RESET "]::.\n";
}

sub HELP_MESSAGE { my $fh = shift; 
		   print $fh BOLD, RED, "  USAGE: ", RESET;
		   print $fh BOLD, BLUE, "./atslurpie.pl " . BOLD, RED "[" . BOLD, CYAN, "-n" . BOLD, RED "]" . BOLD, RED " ["  . BOLD, BLUE, "<" . RESET "search string" . BOLD, BLUE, ">" . BOLD, RED "|" . BOLD CYAN "-f " . BOLD, BLUE, "<" . RESET "filename" . BOLD, BLUE, ">" . RED " {" . BOLD, CYAN, "-s" . RED "}" . BOLD, RED "]\n", RESET;
		   print $fh "\n";
		   print $fh "\tCOMMAND LINE ARGUMENTS\n";
		   print $fh BOLD, BLUE, "\t-n\t\t" . RESET "=> search the AUR tool 'name' field only\n";
		   print $fh BOLD, BLUE, "\t<" . RESET, BOLD "search string" . BOLD, BLUE, ">\t" . RESET "=> your AUR search string\n";
		   print $fh BOLD, BLUE, "\t-f <" . RESET, BOLD "filename" . BOLD, BLUE, ">\t" . RESET "=> search the AUR using a file, with 1 search per line\n";
		   print $fh BOLD, BLUE, "\t-s\t\t" . RESET "=> sort the input file searches NUMBERIC-alphabetically\n";
		   print $fh BOLD, BLUE, "\t--help\t\t" . RESET "=> displays help\n";
		   print $fh BOLD, BLUE, "\t--version\t" . RESET "=> displays version information\n";
		   print $fh "\n";
		   print $fh "\t\tEXAMPLEs:  " . BOLD, BLUE, "atslurpie.pl gdb\n", RESET;
		   print $fh "\t\t           " . BOLD, BLUE, "atslurpie.pl -nsf /tmp/listofsearches.txt\n", RESET;
		   print $fh "\t\t           " . BOLD, BLUE, "atslurpie.pl -n metasploit\n", RESET;
		   print $fh "\n";
}
