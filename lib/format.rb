module Viget
  module Format
    def constant_name
      value = self.strip.gsub(/\s+/, '_').gsub(/[^\w_]/, '').upcase
      value = nil if value.blank?
      value
    end
  end
end

# This only appears to work here, and not in init.rb (need to investigate w/ non-edge Rails)
class String; include Viget::Format; end