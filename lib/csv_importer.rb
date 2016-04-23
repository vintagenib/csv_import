require 'csv'

# CSVImporter provides a means of parsing a CSV file and maping columns to
# ActiveRecord attributes.
#
#
# == Usage
#
# It's assumed that the CSV file to be parsed has a header row with the names
# of the columns.  CSVImporter then simply maps those columns to ActiveRecord
# attributes when creating an objct.
#
# When initializing a new instance of CSVImporter, four keyword arguments are
# required for the importer to properly process the file.  All four of these
# arguments are required (there's no default) in order to force the user to
# ensure that everything is mapped properly.
#
# [path]
#     The full path of the CSV file that is to be parsed.
# [keymap]
#     A Hash that determining how each CSV column is mapped.  The keys of the
#     of the hash correspond to the column names of the CSV file.  The value of
#     each key should be a symbol of the ActiveRecord attribute that you want
#     that column to map to.
# [object_class]
#     This is the class of the ActiveRecord models that you are creating.
#     CSVImporter is expecting the actual class (not a string).
# [defaults]
#     A Hash of some attributes and values that should be included when creating
#     the ActiveRecord models. This Hash will overwrite any overlapping values
#     that may have come in from the CSV file. Defaults is a required argument.
#     If no default values are needed, then simply pass in an empty Hash.
# [delayed]
#     *Optionally* sets whether or not the creation of the ActiveRecord instances
#     should be processed later using Delayed::Job.
#
#
# == Mapping CSV columns to ActiveRecord attributes
#
# The #keymap argument passwed when the CSVImporter is initialized determines
# how the CSV columns are mapped to ActiveRecord attributes.  CSVImporter assumes
# that the first row of the CSV file is a header row.
#
# All of the column headers are converted to lowercase, underscored (replaces
# spaces with underscore characters), and converted to symbols.s
class CSVImporter


  ########################################################


  attr_accessor :parsed_csv, :keymap, :object_class, :defaults, :delayed


  ########################################################


  def initialize(path:, keymap:, object_class:, defaults:, delayed: true )

    @keymap, @object_class, @defaults, @delayed =
      keymap.symbolize_keys, object_class, defaults.symbolize_keys, delayed

    @parsed_csv = CSV.read(path,
      headers: true,
      header_converters: :symbol
    )

  end


  ########################################################


  # Creates a new instance of the #object_class from a CSV row object
  #
  # The +:row+ argument is expected to be an instance of CSV::Row.
  #
  # If +delayed+ remains true and Delayed::Job is installed then the creation
  # of the object is recorded for delayed processing. This comes in handy if you
  # are parsing a large number of rows and the model creation has some time-
  # consuming processing to perform.
  def create_object_from(row:)
    return object_class.create(attributes_for(row: row)) unless delayed
    return object_class.delay.create(attributes_for(row: row))
  end


  ########################################################

  # Builds a complete Hash of the attributes that should be assigned
  # when the #object_class is created.
  def attributes_for(row:)
    parsed_attributes_from(row: row)
      .merge(defaults)
  end

  # Builds a Hash from a CSV::Row based on the #keymap
  def parsed_attributes_from(row:)
    attributes = {}
    keymap.each {|k,v| attributes[v] = row[k] if v }
    attributes
  end


  ########################################################

  # Checks to see that the #keymap covers all the columns in the CSV file.
  def keys_covered?
    keymap.keys.sort == parsed_csv.headers.sort
  end

  # Processes the CSV file and creates saves the ActiveRecord instances to
  # the database.
  def process_file!
    return false unless keys_covered?

    parsed_csv.each { |r| create_object_from(row: r) }
    return true
  end




end
