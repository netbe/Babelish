=Introduction=
This script converts a csv file of translations into iOS .strings files and vice-versa.

=Requirements=
*Needs fastercsv

=Usage=
Convert from CSV file to .strings files 
 ruby convert.rb <filename>.csv

Convert from .strings files to CSV file 'Translations.csv'
 ruby convert.rb <filename1>.strings <filename2>.strings
The csv file needs one column per language and must have headers (for output filenames)

=Todo=
*Add option to choose the reference column to take in account
*Add option for output CSV file
*Add tests suite
