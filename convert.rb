#!/usr/bin/env ruby

require 'rubygems'
begin
  require 'faster_csv'
rescue LoadError
  puts "FasterCSV required! i.e: gem install fastercsv"
  exit
end
#variables
file                                     = nil
basename                                 = nil

#Functions
def dotstrings_to_csv(filenames)
  puts "not yet implemented"
  exit
  
  
  newfile                                = 'Translations.csv'
  common_strings                         = []
  
  filenames.each do |fname|

    FasterCSV.foreach(fname, :quote_char => '"', :col_sep =>'=', :row_sep =>';') do |row|

    end


  end
end  

def csv_to_dotstrings(name)
  files = {}
  rowIndex = 0
  FasterCSV.foreach(name, :quote_char    => '"', :col_sep =>',', :row_sep =>:auto) do |row|
    if rowIndex == 0
      return unless row.count > 1 #check there's at least two columns
    else
      next if row == nil #skip empty lines (or sections)
    end
    row.size.times do |i|
      if rowIndex == 0 #header
        filename = "#{row[i]}.strings"
        puts ">>>Creating file : #{filename}"
        files[i] = File.new(filename,"w")
      else
        value = row[0].strip #@todo: add option to strip the constant or referenced language
        files[i].write "\"#{value}\" = \"#{row[i]}\";\n"
      end
    end
    rowIndex+=1
  end
  puts ">>>Created #{files.size} files. Content: #{rowIndex - 1} translations"
  files.each do |fileIndex,fpointer|
    fpointer.close
  end

end

def usage
  puts "Usage:\n" #@todo: add details about arguments
end

def checks
  if ARGV.size < 1
    puts "Error: not enough arguments"
    usage
    exit
  end
  ARGV.each do |filename|
    if File.extname(filename).downcase == '.csv'
      csv_to_dotstrings(filename)
      return
    end

    if File.extname(filename).downcase != '.strings'
      puts "strings"
      return usage
    end
    dotstrings_to_csv(ARGV)
  end 
end
#main
checks


