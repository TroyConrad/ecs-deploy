#!/usr/bin/perl

=pod =======================================================

=head1 SYNOPSIS

MODULE NAME: ecs-deploy-lib

DESCRIPTION: Common functions library for ecs-deploy, etc.

NOTES: 

AUTHOR: Troy Conrad <troy.conrad@mirumagency.com>

=cut =======================================================

# Version 1.0.1, modified 05Dec2017

###

sub getEnvironmentSettings
{
  my $env = shift;

  # Environment String Map
  my %envOptions = (
  # ENV TYPE       NODE_ENV VALUE   NAME SUFFIX   PORT SUFFIX   INSTANCE #
    'prd'     => [ 'production',    '',           80,           2          ],
    'stg'     => [ 'production',    '-stg',       81,           2          ],
    'qa'      => [ 'qa',            '-qa',        82,           2          ],
    'dev'     => [ 'dev',           '-dev',       83,           1          ]
  );

  $envOptions{$env} or die "'$env' is not a supported environment type";

  return $envOptions{$env};
}

###

sub readFile
{
	($fileName) = @_;

	open my $FILE, '<', $fileName or die "Can't open $fileName: $OS_ERROR";

	my $fileData =  do { local $/; <$FILE> };
	
	# be neat and close file
	close $FILE or die "Cannot close $fileName: $OS_ERROR";

  	return $fileData;
}

###

sub writeFile
{
	($fileName,$fileData) = @_;

	open my $FILE, '>', $fileName or die "Cannot open $taskDefFile: $OS_ERROR";
	
	# write out the data
	print $FILE $fileData or die "Cannot write to $fileName: $OS_ERROR";
	
	# be neat and close file
	close $FILE or die "Cannot close $fileName: $OS_ERROR";

  	return $fileName;
}

###

sub runCmd
{
  my($cmd,$verbose,$ignoreErrors) = @_;
  print color('bold'), "Running '$cmd'...\n", color('reset');
  my $cmdOut = `$cmd`;
  $verbose && print "$cmdOut\n";
  my $exitCode = $? >> 8; # Binary right shift 
  die "Error running '$cmd': $OS_ERROR" if $exitCode and !$ignoreErrors;
  $cmdOut;
}

1;