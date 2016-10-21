require 'set'

module ActiveSupport
  module Inflector
    extend self

    def inflections(lang = :en)
      if block_given?
        yield Inflections.instance
      else
        Inflections.instance
      end
    end

    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?

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
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    def pluralize(word)
      apply_inflections(word, inflections.plurals)
    end

    def singularize(word)
      apply_inflections(word, inflections.singulars)
    end

    def apply_inflections(word, rules)
      result = word.to_s

      if inflections.uncountables.include?(result.downcase)
        result
      else
        rules.each do |rule, replacement|
          changed = result.sub(rule, replacement)
          unless changed == result
            result = changed
            break
          end
        end

        result
      end
    end

    class Inflections
      def self.instance
        @__instance__ ||= new
      end

      attr_reader :plurals, :singulars, :uncountables

      def initialize
        @plurals, @singulars, @uncountables = [], [], Set.new
      end

      def plural(rule, replacement)
        @plurals.unshift([rule, replacement])
      end

      def singular(rule, replacement)
        @singulars.unshift([rule, replacement])
      end

      def uncountable(words)
        words.each { |w| @uncountables << w.downcase }
      end

      def irregular()

      end
    end
  end
end
