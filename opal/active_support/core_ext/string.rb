require 'active_support/core_ext/string/filters'
require 'active_support/core_ext/string/inflections'

class String
  def parameterize
    self.downcase.strip.gsub(/\W+/, '-')
  end
end
