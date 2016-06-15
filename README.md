# vcard2snom

## Description

vcard2snom can be used to convert vcard files (e.g. owncloud address books) to xml files ready to be imported by Snom phones.

## Usage

* get your vcard file, e.g. download it from a running owncloud server via `https://<yourOwncloudServer>/owncloud/carddav/addressbooks/<yourOwncloudUsername>/<yourOwncloudCalendarName>?export`
* run vcard2snom with your vcard file as input, direct output to your desired xml file:

    `$ perl vcard2snom.pl <yourVcardFile> > phonebook.xml`

* if necessary, convert to UTF8:

    `$ iconv -f UTF-8 -t ISO-8859-15 phonebook.xml -c > snom.xml`

* upload snom.xml in the Snom phone web gui

## References

* Snom xml structure: http://downloads.snom.net/documentation/M700_M300_Admin_Guide_en.pdf, page 43