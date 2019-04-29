$makeindex = 'texindy -M %B.xdy %O -o %D %S'; #$
$pdf_mode = 4; #4 means luatex, 1 latex, 5 xetex, however not sure if it override commandline arguments

warn_running( "Asciimint=> Latexmkrc: this is makeindex command: '$makeindex'" );

#$makeindex = 'texindy -M index.xdy';
#$makeindex = 'xindy %O -o %D %S';
#$makeindex = 'texindy %O -o %D %S';

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  }
  else {
    system "makeglossaries '$_[0]'";
  };
}
    
