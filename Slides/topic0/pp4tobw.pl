#!/usr/bin/perl -w

# mangle Chris Adolph's tex

# delete any occurances of these
#\renewcommand\normalcolor{\color{XXX}}
#\textcolor{XXX}
#\vpagecolor[XXX]{XXX}
#\color(XXX)
#\pause

# before "\begin{document}", insert
#\color{black}
#\pagecolor{white}
#\renewcommand\normalcolor{\color{black}}


# arguments
if ( $#ARGV ne 1 ) { 
  print "Usage: $0 <infile> <outfile>";
  exit;
}

# input & output files
$infile = $ARGV[0];
if ( !-e $infile ) {
  print "Error: file \"$infile\" does not appear to exist.\n";
  exit;
}

$outfile = $ARGV[1];
if ( $infile eq $outfile ) {
  print "Error: infile and outfile must be different.";
  exit;
}

# open & read the input file
open (INFILE, "<$infile");
@inlines = <INFILE>;
close INFILE;

# open the output file
open (OUTFILE, ">$outfile");

# start processessing
foreach $line (@inlines) {
  chomp $line;
  if ($line =~ m/\\usepackage\{color\}/) {
    print OUTFILE "$line\n";
    print OUTFILE "\\color\{black\}\n";
    print OUTFILE "\\pagecolor\{white\}\n";
    print OUTFILE "\\renewcommand\\normalcolor\{\\color\{black\}\}\n";
  } else {
    $line =~ s/\\renewcommand\\normalcolor\{\\color\{[a-z][a-z]*\}\}//;
    $line =~ s/\\textcolor\{[a-z][a-z]*\}//;
    $line =~ s/\\vpagecolor\[.*\]\{.*\}//;
    $line =~ s/\\pagecolor\{.*\}//;
    $line =~ s/\\color\{[a-z][a-z]*\}//g;
    $line =~ s/\\pause//;
    print OUTFILE "$line\n";
  }
}

# close the output
close OUTFILE;





