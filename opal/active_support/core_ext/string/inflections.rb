class String
  def pluralize
    ActiveSupport::Inflector.pluralize(self)
  end

  def singularize
    ActiveSupport::Inflector.singularize(self)
  end
end
