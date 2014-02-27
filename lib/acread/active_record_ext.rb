require 'active_record'
require 'acread/deprecatable'

class ActiveRecord::Base

  include Deprecatable

  def self.columns
   super.reject { |c| (self.deprecated_attributes || []).include? c.name.to_s}
  end

  def attribute_names
    @attributes.keys.reject { |k| (self.class.deprecated_attributes || []).include? k.to_s}
  end

  # ensure the deprecated attributes will be skip when serialize the record

  alias_method :super_serializable_hash, :serializable_hash
  def serializable_hash(options = {})
    options = {} if options.nil?
    options = {
      :only => self.attributes.keys.map(&:to_sym) - (self.class.deprecated_attributes || []).map(&:to_sym)
    }.update(options)
    super_serializable_hash(options)
  end

end
