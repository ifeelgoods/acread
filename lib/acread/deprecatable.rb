module Deprecatable

  def self.included(base)
    base.extend ClassMethods
  end

  ACCESSORS = [ '', '=', '_before_type_cast', '?', '_changed?', '_change', '_will_change!', '_was']

  module ClassMethods
    def deprecate_attribute(attr, opts={})
      opts ||={}
      @deprecated_attributes ||=[]
      @deprecated_attributes << attr.to_s
      overide_accessors attr, opts
    end

    def deprecated_attributes
      @deprecated_attributes || []
    end

    def accessors
      # TODO: replace this constant by an ActiveRecord inspection
      ACCESSORS
    end

    def overide_accessors(attr, opts)
      msg = "You can't access atribute #{attr}, it has been deprecated"
      accessors.each do |term|
        define_method("#{attr}#{term}") do |*args|
          raise DeprecatedAttributeError, msg
          (args.length >0 ? super(args) : super()).first # call ActiveRecord behavior if previous exception have been continued
        end
      end
    end

    def respond_to?(*args)
      if deprecated_attributes.include?(args[0])
        false
      else
        super
      end
    end
  end

  class DeprecatedAttributeError < Exception
  end

end


