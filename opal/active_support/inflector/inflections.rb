module ActiveSupport
  module Inflector
    extend self

    def inflections
      if block_given?
        yield Inflections.instance
      else
        Inflections.instance
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
