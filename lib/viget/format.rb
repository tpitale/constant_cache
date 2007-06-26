module Viget
  class Format
    def self.to_const(string)
      value = string.strip.gsub(/\s+/, '_').gsub(/[^\w_]/, '').upcase
      value = nil if value.blank?
      value
    end
  end
end