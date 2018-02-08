require "active_support/inflections"

module ActiveSupport
  module Inflector
    extend self

    def pluralize(word, locale = :en)
      apply_inflections(word, inflections(locale).plurals, locale)
    end

    def singularize(word, locale = :en)
      apply_inflections(word, inflections(locale).singulars, locale)
    end

    def camelize(term, uppercase_first_letter = true)
      string = term.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      else
        string = string.downcase
      end
      string = string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string = string.gsub("/".freeze, "::".freeze)
      string
    end

    def underscore(camel_cased_word)
      return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)
      word = camel_cased_word.to_s.gsub("::".freeze, "/".freeze)
      word = word.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word = word.gsub(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word = word.tr("-".freeze, "_".freeze)
      word = word.downcase
      word
    end

    def humanize(lower_case_and_underscored_word, capitalize: true, keep_id_suffix: false)
      result = lower_case_and_underscored_word.to_s.dup

      inflections.humans.each do |(rule, replacement)|
        if (rule.is_a?(Regexp) && result =~ rule) || (rule.is_a?(String) && result == rule)
          result = result.sub(rule, replacement)
          break
        end
      end

      result = result.sub(/\A_+/, "".freeze)
      unless keep_id_suffix
        result = result.sub(/_id\z/, "".freeze)
      end
      result = result.tr("_".freeze, " ".freeze)

      result = result.gsub(/([a-z\d]*)/i) do |match|
        "#{match.downcase}"
      end

      if capitalize
        result = result.sub(/\A\w/) { |match| match.upcase }
      end

      result
    end

    def upcase_first(string)
      string.length > 0 ? string[0].upcase + string[1..-1] : ""
    end

    def titleize(word, keep_id_suffix: false)
      humanize(underscore(word), keep_id_suffix: keep_id_suffix).gsub(/([a-zA-Z'’`])[a-z]*/) do |match|
        match.capitalize
      end
    end

    def tableize(class_name)
      pluralize(underscore(class_name))
    end

    def classify(table_name)
      # strip out any leading schema name
      camelize(singularize(table_name.to_s.sub(/.*\./, "".freeze)))
    end

    def dasherize(underscored_word)
      underscored_word.tr("_".freeze, "-".freeze)
    end

    def demodulize(path)
      path = path.to_s
      if i = path.rindex("::")
        path[(i + 2)..-1]
      else
        path
      end
    end

    def deconstantize(path)
      path.to_s[0, path.rindex("::") || 0] # implementation based on the one in facets' Module#spacename
    end

    def foreign_key(class_name, separate_class_name_and_id_with_underscore = true)
      underscore(demodulize(class_name)) + (separate_class_name_and_id_with_underscore ? "_id" : "id")
    end

    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      # FIXME: initially was
      # Object.const_get(camel_cased_word) if names.empty?
      # Changed because Opal can't handles such case
      # Instead it throws something like <NoMethodError: undefined method 'upcase' for nil>
      raise NameError, 'wrong constant name ' if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    def safe_constantize(camel_cased_word)
      constantize(camel_cased_word)
    rescue NameError => e
      raise if e.name && !(camel_cased_word.to_s.split("::").include?(e.name.to_s) ||
        e.name.to_s == camel_cased_word.to_s)
    rescue ArgumentError => e
      raise unless /not missing constant #{const_regexp(camel_cased_word)}!$/.match?(e.message)
    end


    def ordinal(number)
      abs_number = number.to_i.abs

      if (11..13).include?(abs_number % 100)
        "th"
      else
        case abs_number % 10
        when 1; "st"
        when 2; "nd"
        when 3; "rd"
        else    "th"
        end
      end
    end

    def ordinalize(number)
      "#{number}#{ordinal(number)}"
    end

    private

      def const_regexp(camel_cased_word)
        parts = camel_cased_word.split("::".freeze)

        return Regexp.escape(camel_cased_word) if parts.blank?

        last = parts.pop

        parts.reverse.inject(last) do |acc, part|
          part.empty? ? acc : "#{part}(::#{acc})?"
        end
      end

      def apply_inflections(word, rules, locale = :en)
        result = word.to_s.dup

        if word.empty? || inflections(locale).uncountables.uncountable?(result)
          result
        else
          rules.each do |(rule, replacement)|
            if (rule.is_a?(Regexp) && result =~ rule) || (rule.is_a?(String) && result == rule)
              result = result.sub(rule, replacement)
              break
            end
          end
          result
        end
      end
  end
end
