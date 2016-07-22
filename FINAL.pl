#!usr/bin/perl

use strict;

use Data::Dumper qw(Dumper);
use 5.010;
my $TotalNoOfFiles = `wc -l < Files1.txt`;

open(FILES, "< Files1.txt") or die ("Couldn't open the file");
my @FilesArray = <FILES>;
close(FILES);

##############---Initial Read for Number of Variables---##################
open(SAMPLE, "<parameter-|temp=0|.raw") or die ("Couldn't open the file");
my @InitialReadVariablePoints = <SAMPLE>;
my @SplitArray;
my $NoOfVariables;
my $NoOfPoints;
foreach my $line1(@InitialReadVariablePoints) {
	@SplitArray = split(' ', $line1);
	if($SplitArray[1] eq "Variables:") { $NoOfVariables = $SplitArray[2];}
	if($SplitArray[1] eq "Points:"){
		$NoOfPoints    = $SplitArray[2];
		last;
		}	 
}
print "NoOfVariables	: $NoOfVariables\n";
print "NoOfPoints 	: $NoOfPoints\n";
close(SAMPLE);


####################---Select the Input Parameter---############################
my $flag=0;

print "Select one parameter from the following (1 to 4): \n";
print "0:	v-sweep	voltage\n";	#Default Parameter.. Printed Everytime
print "1:	drain	voltage\n";
print "2:	gate 	voltage\n";
print "3:	i(vvds) current\n";
print "4:	i(vvgs) current\n";

my $SelectionInput = <STDIN>;
chomp($SelectionInput);


######################---Display Logic---##################################
open(OUTFILE, ">FINAL_OUTPUT.txt") or die("Can't Open the File");
open(DEMOFILE, "<parameter-|temp=0|.raw") or die("Couldn't Open the File");

my @Display = <DEMOFILE>;
my $count = 0;

for ($count = 0; $count < 8+$TotalNoOfFiles; $count++) {
	if($count < 4) {
		print OUTFILE "$Display[$count]";		
		}
	if($count == 4) {
		print OUTFILE "No. Variables: ", $TotalNoOfFiles+1, "\n";
		}
	if($count == 5) {
		print OUTFILE "No. Points: ", $NoOfPoints, "\n"; 

		}
	if(($count == 6) || ($count == 7)) {
		print OUTFILE "$Display[$count]";
		}
	if ($count > 7 && ($count< (8+$TotalNoOfFiles))) {
		 my $varName= $FilesArray[$count-8];
		 $varName =~ s/parameter-\|//;
		 $varName =~ s/\|\.raw//; 
		print OUTFILE "	",$count-7,"	$varName"; 		
		}
		
}


print OUTFILE "Values: "; 

close(DEMOFILE);
 
####################---Initialize Array of Arrays---############################

my @AoA;
my $Offset=13;

my $i;
my $j;
my $k;
for ( $i=0; $i <$NoOfPoints; $i++) {
	for( $j =0; $j <$TotalNoOfFiles; $j++) {
		for( $k= 0; $k < $NoOfVariables+1; $k++) {
			open(SAMPLEFILE, "<$FilesArray[$j]") or die ("Couldn't find the file");			
			my @SampleFile = <SAMPLEFILE>;					
			$AoA[$i][$j][$k] = $SampleFile[$k+$Offset]; 			
			}
			
		}
			
			$Offset = $Offset + 6;	
			
}

#say Dumper \@AoA;
##################---Check to See if Correct Values are Present---#################
print "------------------------------------\n";
print "$AoA[0][2][0]";
print "$AoA[0][2][1]";
print "$AoA[0][2][2]";
print "$AoA[0][2][3]";
print "$AoA[0][2][4]";
print "$AoA[0][2][5]";

print "=====================================\n";



print "$AoA[33][2][0]";
print "$AoA[33][2][1]";
print "$AoA[33][2][2]";
print "$AoA[33][2][3]";
print "$AoA[33][2][4]";
print "$AoA[33][2][5]";

print "------------------------------------\n";
close(SAMPLEFILE);


######################---Iterating through the Loop---#############################


for ($i =0; $i< $NoOfPoints; $i++) {
		print OUTFILE "\n";
		print OUTFILE "$AoA[$i][0][0]";
		for($j =0; $j <$TotalNoOfFiles; $j++) {
									
			for($k= 0; $k < $NoOfVariables+1; $k++){
				if($k == $SelectionInput) {							
				print OUTFILE "$AoA[$i][$j][$k]"; 		
				}
					
			}	
			
		}

}

print OUTFILE "\n";
print OUTFILE "\n";
print OUTFILE "\n";
print OUTFILE "Yohoooooooooooooooooo!!\n";
#########################################################################################

close(OUTFILE);


