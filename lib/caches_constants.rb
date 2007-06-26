module ActiveRecord
  class Base
    class << self
      def caches_constants(additional_options = {})
        options = {:key => :name, :limit => 64}.merge(additional_options)
        find(:all).each do |model| 
          const = Viget::Format.to_const(model.send(options[:key].to_sym))
          const = const[0, options[:limit]] unless const.blank?
          set_constant = !const.blank? && !const_defined?(const)
          const_set(const, model) if set_constant
        end
      end
    end
  end
end