# Introduction
This script converts a csv file of translations into iOS .strings files and vice-versa.

# Requirements
* Needs fastercsv with ruby > 1.9

# Usage
Convert from CSV file to .strings files
```
./convert.rb filename.csv
```
The csv file needs one column per language and must have headers (for output filenames)

Convert from .strings files to CSV file 'Translations.csv' (configurable)
```
./convert.rb filename1.strings filename2.strings
```
or to convert all xx.lproj/Localizable.strings to CSV
```
./convert.rb
```

Place <code>i18n_config.rb</code> (edit if needed) in the folder with your xx.lproj and call the script from there
```
cp .i18n_config.rb iOSProject/resources/i18n_config.rb
cd iOSProject/resources
script/path/convert.rb
```

# Todo
* Add option for output CSV file
* Add tests suite
