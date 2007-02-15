#!/usr/bin/perl -w
# Author: Andreas Weber <andreas@it-weber.com>
# Date: 12.01.2007
# Purpose: To control settings in /etc/apt/sources.lst
#
#---------------------------------------------------------
# Todo: 
#	Finish basic Functions
#	Add http/ftp switcher
# 	Add mirror switcher
#	# Experimental
#	deb http://ftp.de.debian.org/debian experimental main contrib non-free
#	deb-src http://ftp.de.debian.org/debian experimental main contrib non-free
#---------------------------------------------------------
# Changelog:
#	08.01.2007: Andreas Weber: Started with Script 
#
#
#use strict;
#use warnings;

# Setup Variables
my $debug = 0;
my $SOURCEFILE = "/etc/apt/sources.list";
my $IN = "INFILE";
my $OUT = "OUTFILE";
my $TARGETFILE = "/etc/apt/sources.list";
my $DEBIAN_URI = "http://ftp.debian.org/debian";
my $DEBMM_URI = "http://www.debian-multimedia.org";
my $SIDUX_URI = "http://sidux.com/debian/";
my $time = localtime;
my $numArgs = $#ARGV + 1;
my $CMD_DEBIAN = 0;
my $CMD_SIDUX = 0;
my $CMD_DEBMM = 0;
my $WRITE_DEFAULT = 0;
my $ACONTRIB = 0;
my $DCONTRIB = 0;
my $ANONFREE = 0;
my $DNONFREE = 0;

sub activate_debug() {
# This subroutine will activate debugging
	print "+++ We have ", $#ARGV + 1, " argument(s):\n";
	foreach (@ARGV) {
		print "+++ \t$_\n";
	}
	print "+++ End arguments.\n";
}

sub write_default() {
# This subroutine will write a default sources.list
open ($OUT, ">$TARGETFILE")|| die "Unable to open $TARGETFILE\n$!\n";
print $OUT "\# See sources.list(5) for more information, especialy
# Remember that you can only use http, ftp or file URIs
# CDROMs are managed through the apt-cdrom tool.

# Unstable
deb http://ftp.debian.org/debian/ sid main
deb-src http://ftp.debian.org/debian/ sid main

# Testing
deb http://ftp.debian.org/debian/ testing main
deb-src http://ftp.debian.org/debian/ testing main

# Sidux Sources
deb http://sidux.com/debian/ sid main fix.main
deb-src http://sidux.com/debian/ sid main fix.main\n";
print "$TARGETFILE created.\n";
}

sub activate_contrib() {
# This subroutine will activate contrib for debian and sidux entrys
	if ( ! -e $TARGETFILE ) {
		write_default();
	}
	open ($IN, "$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	my @edit_array = <$IN>;
	foreach (@edit_array) {
		#print "$_";
		if ($CMD_DEBIAN == 1) {
			if (/$DEBIAN_URI/) {
				if (! /contrib/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ contrib\n";
					print "+++ $_\n"; 
				}
			}
		}
		if ($CMD_SIDUX == 1) {
			if (/$SIDUX_URI/) {
				if (! /contrib/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ contrib\n";
					print "+++ $_\n"; 
				}
			}
		}
		if ($CMD_DEBMM == 1) {
			if (/$DEBMM_URI/) {
				if (! /contrib/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ contrib\n";
					print "+++ $_\n";
				}
			}
		}
	}

	unlink($TARGETFILE);
	open ($OUT, ">>$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	print $OUT @edit_array;
	if ("$debug" == 1) {print "@edit_array\n";}
}

sub deactivate_contrib() {
# This subroutine will deactivate contrib for debian and sidux entrys
	if ( ! -e $TARGETFILE ) {
		write_default();
	}
	open ($IN, "$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	my @edit_array = <$IN>;
	foreach (@edit_array) {
		#print "$_";
		if ($CMD_DEBIAN == 1) {
			if (/$DEBIAN_URI/) {
				if (/\s+contrib/) {
					print "--- $_";
					s/\s+contrib//;
					print "+++ $_";
				}
			}
		}
		if ($CMD_SIDUX == 1) {
			if (/$SIDUX_URI/) {
				if (/contrib/) {
					print "--- $_";
					s/\s+contrib//;
					print "+++ $_"; 
				}
			}
		}
		if ($CMD_DEBMM == 1) {
			if (/$DEBMM_URI/) {
				if (/contrib/) {
					print "--- $_";
					s/\s+contrib//;
					print "+++ $_"; 
				}
			}
		}
	}

	unlink($TARGETFILE);
	open ($OUT, ">>$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	print $OUT @edit_array;
	if ("$debug" == 1) {print "@edit_array\n";}
}

sub activate_nonfree() {
# This subroutine will activate non-free for debian and sidux entrys
	if ( ! -e $TARGETFILE ) {
		write_default();
	}
	open ($IN, "$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	my @edit_array = <$IN>;
	foreach (@edit_array) {
		#print "$_";
		if ($CMD_DEBIAN == 1) {
			if (/$DEBIAN_URI/) {
				if (! /non\-free/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ non\-free\n";
					print "+++ $_\n";
				}
			}
		}
		if ($CMD_SIDUX == 1) {
			if (/$SIDUX_URI/) {
				if (! /non\-free/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ non\-free\n";
					print "+++ $_\n";
				}
			}
		}
		if ($CMD_DEBMM == 1) {
			if (/$DEBMM_URI/) {
				if (! /non\-free/) {
					chomp;
					print "--- $_\n";
					$_ = "$_ non\-free\n";
					print "+++ $_\n";
				}
			}
		}
	}

	unlink($TARGETFILE);
	open ($OUT, ">>$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	print $OUT @edit_array;
	if ("$debug" == 1) {print "@edit_array\n";}
}

sub deactivate_nonfree() {
# This subroutine will deactivate contrib for debian and sidux entrys
	if ( ! -e $TARGETFILE ) {
		write_default();
	}
	open ($IN, "$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	my @edit_array = <$IN>;
	foreach (@edit_array) {
		#print "$_";
		if ($CMD_DEBIAN == 1) {
			if (/$DEBIAN_URI/) {
				if (/\s+non\-free/) {
					print "--- $_";
					s/\s+non\-free//;
					print "+++ $_";
				}
			}
		}
		if ($CMD_SIDUX == 1) {
			if (/$SIDUX_URI/) {
				if (/non\-free/) {
					print "--- $_";
					s/\s+non\-free//;
					print "+++ $_"; 
				}
			}
		}
		if ($CMD_DEBMM == 1) {
			if (/$DEBMM_URI/) {
				if (/non\-free/) {
					print "--- $_";
					s/\s+non\-free//;
					print "+++ $_";
				}
			}
		}
	}

	unlink($TARGETFILE);
	open ($OUT, ">>$TARGETFILE")|| die "Cannot open $TARGETFILE.\n$!\n";
	print $OUT @edit_array;
	if ("$debug" == 1) {print "@edit_array\n";}
}

# Parse arguments from cmdline
if ($#ARGV < 0) {
	print "Usage ";
}

foreach (@ARGV) {
	if (/debian/) {
		$CMD_DEBIAN = 1;
	}
	if (/sidux/) {
		$CMD_SIDUX = 1;
	}
	if (/debmm/) {
		$CMD_DEBMM = 1;
	}
	if (/-d|--debug/) {
		$debug = 1;
	}
	if (/-D|--default/) {
		$WRITE_DEFAULT = 1; 
	}
	if (/-ca|--contrib-add/) {
		$ACONTRIB = 1;
	}
	if (/-cd|--contrib-del/) {
		$DCONTRIB = 1;
	}
	if (/-na|--non-free-add/) {
		$ANONFREE = 1;
	}
	if (/-nd|--non-free-del/) {
		$DNONFREE = 1;
	}

}

# Apply CMDLINE
if ($debug == 1) {
	print "Debug mode is on.\n";
	activate_debug();
}

if ($WRITE_DEFAULT == 1) {
	print "Writing default File.\n";
	write_default();
}

if ($ACONTRIB == 1) {
	print "Activating Contrib\n";
	activate_contrib();
}

if ($DCONTRIB == 1) {
	print "Deactivating Contrib\n";
	deactivate_contrib();
}

if ($ANONFREE == 1) {
	print "Activating non-free\n";
	activate_nonfree();
}

if ($DNONFREE == 1) {
	print "Deactivating non-free\n";
	deactivate_nonfree();
}

# call common Functions


# END

