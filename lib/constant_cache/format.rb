module ConstantCache
  module Format
    def constant_name
      value = self.strip.gsub(/\s+/, '_').gsub(/[^\w_]/, '').gsub(/_{2,}/, '_').upcase
      value = nil if value.blank?
      value
    end
  end
end