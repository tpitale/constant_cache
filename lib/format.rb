module Viget
  module Format
    def constant_name
      value = self.strip.gsub(/\s+/, '_').gsub(/[^\w_]/, '').upcase
      value = nil if value.blank?
      value
    end
  end
end