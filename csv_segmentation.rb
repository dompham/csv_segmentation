#!/usr/bin/env ruby
require "CSV"

class CSVSegmentation
  #  Trying to use Hashes whenever I can to speed up the lookups.
  def initialize(source_path, schema_path)
    # Class CSV Table, essentially a list of hashes {HEADER: KEY}
    @source_csv = CSV.parse(File.read(source_path), headers: true)
    @schema_hash = CSV.parse(File.read(schema_path), converters: %i[numeric], headers: true)[0].to_h
  end

  def execute
    # do validations here, make sure schema is valid
    # get max number of csvs by finding max value.
    num_csvs_to_create = @schema_hash.max_by{|k,v| v == "R" ? 0 : v}.last
    create_csvs(num_csvs_to_create)
  end

  # Create n CSVs, each with their own headers.
  # After creating them, populate each one with the data based on schema.
  def create_csvs(csv_count)
    for num in 1..csv_count
      headers = filtered_schema_headers(num)
      CSV.open("data#{num}.csv", "w",:write_headers => true, :headers => headers) do |csv|
        populate_csv(csv, headers)
      end
    end
  end

  # Use filtered headers to fill in CSV.
  def populate_csv(csv, headers)
    @source_csv.each do |row|
      csv << [].tap do |arr|
        headers.each do |k, v|
          arr.push(row.to_h.fetch(k, nil))
        end
      end
    end
  end

  # Given a filter (number) return an array of repeaters+filter keys
  def filtered_schema_headers(filter)
  repeater_keys = @schema_hash.select {|k,v| v == "R"}.keys
  filter_keys = @schema_hash.select {|k,v| v == filter}.keys

  return repeater_keys + filter_keys
  end
end

CSVSegmentation.new(ARGV[0], ARGV[1]).execute



# ruby csv_segmentation.rb sample_export.csv seg_schema.csv
# ruby csv_segmentation.rb small_scale_export.csv small_scale_schema.csv
