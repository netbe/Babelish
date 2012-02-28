# Introduction
This script converts a csv file of translations into iOS .strings files and vice-versa.

# Requirements
* Needs fastercsv

# Usage
Convert from CSV file to .strings files 
<code>
  ruby convert.rb <i>filename.csv</i>
</code>
The csv file needs one column per language and must have headers (for output filenames)

Convert from .strings files to CSV file 'Translations.csv'
<code>
 ruby convert.rb <i>filename1.strings</i> <i>filename2.strings</i>
</code>



# Todo
* Add option to choose the reference column to take in account
* Add option for output CSV file
* Add tests suite

