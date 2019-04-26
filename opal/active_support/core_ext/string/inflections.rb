require 'active_support/inflector'

class String
  def pluralize(count = nil, locale = :en)
    locale = count if count.is_a?(Symbol)
    if count == 1
      dup
    else
      ActiveSupport::Inflector.pluralize(self, locale)
    end
  end

  def singularize(locale = :en)
    ActiveSupport::Inflector.singularize(self, locale)
  end

  def constantize
    ActiveSupport::Inflector.constantize(self)
  end

  def safe_constantize
    ActiveSupport::Inflector.safe_constantize(self)
  end

  def camelize(first_letter = :upper)
    case first_letter
    when :upper
      ActiveSupport::Inflector.camelize(self, true)
    when :lower
      ActiveSupport::Inflector.camelize(self, false)
    else
      raise ArgumentError, "Invalid option, use either :upper or :lower."
    end
  end
  alias_method :camelcase, :camelize

  def titleize(keep_id_suffix: false)
    ActiveSupport::Inflector.titleize(self, keep_id_suffix: keep_id_suffix)
  end
  alias_method :titlecase, :titleize

  def underscore
    ActiveSupport::Inflector.underscore(self)
  end

  def dasherize
    ActiveSupport::Inflector.dasherize(self)
  end

  def demodulize
    ActiveSupport::Inflector.demodulize(self)
  end

  def deconstantize
    ActiveSupport::Inflector.deconstantize(self)
  end

  def tableize
    ActiveSupport::Inflector.tableize(self)
  end

  def classify
    ActiveSupport::Inflector.classify(self)
  end

  def humanize(capitalize: true, keep_id_suffix: false)
    ActiveSupport::Inflector.humanize(self, capitalize: capitalize, keep_id_suffix: keep_id_suffix)
  end

  def upcase_first
    ActiveSupport::Inflector.upcase_first(self)
  end

  def foreign_key(separate_class_name_and_id_with_underscore = true)
    ActiveSupport::Inflector.foreign_key(self, separate_class_name_and_id_with_underscore)
  end
end
