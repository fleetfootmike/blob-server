#!/usr/bin/perl
# vi: set ts=4 sw=4 :

use warnings;
use strict;

package BlobServer::Upload;

use Apache2::Const qw(
	HTTP_METHOD_NOT_ALLOWED
	HTTP_CREATED
	OK
	HTTP_INTERNAL_SERVER_ERROR
);
use Apache2::RequestRec;
use Apache2::Response;
use Apache2::RequestIO;

use File::Temp 'tempfile';

sub handler {
	my ($r) = @_;

	return HTTP_METHOD_NOT_ALLOWED
		unless $r->method eq "POST";

	# TODO reject if multipart or form-data
	# (just to stop the common errors)

	my $t = $r->subprocess_env("TMP_DIR");

	my ($fh, $name) = tempfile(
		"upload-XXXXXXXX",
		DIR => $t,
	) or do {
		my $err = $!;
		unlink $name;
		print STDERR "Error: $err\n";
		$r->content_type("text/plain");
		$r->print("Error: $err\n");
		return HTTP_INTERNAL_SERVER_ERROR;
	};

	# TODO receive the request-body and spool into $fh
	# TODO close the file
	# TODO checksum the file
	# TODO rename according to the checksum
	# TODO set Location header, HTTP_CREATED

	$r->content_type("text/plain");
	$r->print("feh\n");

	return OK;
}

1;
