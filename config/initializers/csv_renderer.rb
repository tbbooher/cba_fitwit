
require 'csv'

#class Array
#  def to_csv
#
#    raise "#{first.class.name} can't be converted to CSV" unless first.respond_to? :as_csv
#    self.map &:as_csv
#  end
#end

class Array 
  alias old_to_csv to_csv #keep reference to original to_csv method

  def to_csv
    return "" if empty?
    # override only if first element actually has as_csv method
    return old_to_csv unless first.respond_to? :as_csv
    # use keys from first row as header columns
    out = first.as_csv.keys.to_csv
    self.each { |r| out << r.as_csv.values.to_csv }
    out
  end
end

ActionController::Renderers.add :csv do |csv, options|
  self.content_type ||= Mime::CSV
  csv.respond_to?(:to_csv) ? csv.to_csv : csv
end
