require 'active_support/inflector'

class String
  def pluralize
    p = ActiveSupport::Inflector.pluralize(self)

    msg = "#{__FILE__}[#{__LINE__}] : String#pluralize : '#{self}' => '#{p}' "
    if RUBY_PLATFORM == 'opal'
      `console.log(msg`
    else
      puts msg
    end
  end

  def singularize
    ActiveSupport::Inflector.singularize(self)
  end

  def constantize
    ActiveSupport::Inflector.constantize(self)
  end
end
