#!/usr/bin/perl -w

use strict;
use warnings;

my %addressbook;

my $vcardFile = $ARGV[0];

open VCARD, "$vcardFile" or die $!;

my $index = 0;

my $prefCellFound;
my $prefHomeFound;
my $prefWorkFound;

# go over all lines in the vcard file
while (<VCARD>)
{
    # beginning of new vcard entry
    if ($_ =~ m/BEGIN:VCARD/i)
    {
	$index++;
	$prefCellFound = 0;
	$prefHomeFound = 0;
	$prefWorkFound = 0;
    }
    # full name
    if ($_ =~ m/^FN:(.+)$/i)
    {
	my $name = $1;
	chop($name);
	$addressbook{$index}{name} = $name;
    }
    # telephone
    if ($_ =~ m/^TEL:(.*)$/i)
    {
	my $strippedTel = $1;
	$strippedTel =~ s/ //g;
	$strippedTel =~ s/\(//g;
	$strippedTel =~ s/\)//g;
	$strippedTel =~ s/-//g;
	$strippedTel =~ s/\+/00/g;
	chop($strippedTel);
	$addressbook{$index}{telephone} = $strippedTel;
    }
    # cell phone
    if ($_ =~ m/^TEL;TYPE=.*CELL.*:(.*)$/i)
    {
	if ($prefCellFound == 0)
	{
	    my $strippedTel = $1;
	    $strippedTel =~ s/ //g;
	    $strippedTel =~ s/\(//g;
	    $strippedTel =~ s/\)//g;
	    $strippedTel =~ s/-//g;
	    $strippedTel =~ s/<U//g;
	    $strippedTel =~ s/\+/00/g;
	    chop($strippedTel);
	    $addressbook{$index}{mobile} = $strippedTel;

	    # don't look further if we've found the preferred phone number
	    if ($_ =~ m/PREF/i)
	    {
		$prefCellFound = 1;
	    }
	}
    }
    # home phone
    if ($_ =~ m/^TEL;TYPE=.*HOME.*:(.*)$/i)
    {
	if ($prefHomeFound == 0)
	{
	    my $strippedTel = $1;
	    $strippedTel =~ s/ //g;
	    $strippedTel =~ s/\(//g;
	    $strippedTel =~ s/\)//g;
	    $strippedTel =~ s/-//g;
	    $strippedTel =~ s/\+/00/g;
	    chop($strippedTel);
	    $addressbook{$index}{telephone} = $strippedTel;

	    # don't look further if we've found the preferred phone number
	    if ($_ =~ m/PREF/i)
	    {
		$prefHomeFound = 1;
	    }
	}
    }
    # work phone
    if ($_ =~ m/^TEL;TYPE=.*WORK.*:(.*)$/i)
    {
	if ($prefWorkFound == 0)
	{
	    my $strippedTel = $1;
	    $strippedTel =~ s/ //g;
	    $strippedTel =~ s/\(//g;
	    $strippedTel =~ s/\)//g;
	    $strippedTel =~ s/-//g;
	    $strippedTel =~ s/\+/00/g;
	    chop($strippedTel);
	    $addressbook{$index}{office} = $strippedTel;

	    # don't look further if we've found the preferred phone number
	    if ($_ =~ m/PREF/i)
	    {
		$prefWorkFound = 1;
	    }
	}
    }
}

close VCARD;

print "<IPPhoneDirectory>\n";

# loop over all entries in the collected addressbook and populate the xml structure
foreach my $entry (keys %addressbook)
{
    print "  <DirectoryEntry>\n";
    print "    <Name>$addressbook{$entry}{name}<\/Name>\n";

    my $telephone;
    if (defined($addressbook{$entry}{telephone}))
    {
	$telephone = $addressbook{$entry}{telephone};
    }
    else
    {
	$telephone = "";
    }
    print "    <Telephone>$telephone<\/Telephone>\n";

    my $office;
    if (defined($addressbook{$entry}{office}))
    {
	$office = $addressbook{$entry}{office};
    }
    else
    {
	$office = "";
    }
    print "    <Office>$office<\/Office>\n";

    my $mobile;
    if (defined($addressbook{$entry}{mobile}))
    {
	$mobile = $addressbook{$entry}{mobile};
    }
    else
    {
	$mobile = "";
    }
    print "    <Mobile>$mobile<\/Mobile>\n";

    print "  <\/DirectoryEntry>\n\n";
}

print "<\/IPPhoneDirectory>\n"
