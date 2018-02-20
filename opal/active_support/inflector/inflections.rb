require 'set'

module ActiveSupport
  module Inflector
    extend self

    class Inflections
      @__instance__ = {}

      class Uncountables < Array
        def <<(*word)
          add(word)
        end

        def add(words)
          words = words.flatten.map(&:downcase)
          concat(words)
          self
        end

        def uncountable?(str)
          include?(str.downcase)
        end

        def dup
          copy = Uncountables.new
          copy.add(self)
          copy
        end
      end


      def self.instance(locale)
        @__instance__[locale] ||= new
      end

      attr_reader :plurals, :singulars, :uncountables, :humans

      def initialize
        @plurals, @singulars, @uncountables, @humans = [], [], Uncountables.new, []
      end

      def initialize_dup(orig) # :nodoc:
        %w(plurals singulars uncountables humans).each do |scope|
          instance_variable_set("@#{scope}", orig.send(scope).dup)
        end
      end


      def plural(rule, replacement)
        @uncountables.delete(rule) if rule.is_a?(String)
        @uncountables.delete(replacement)
        @plurals.unshift([rule, replacement])
      end

      def singular(rule, replacement)
        @uncountables.delete(rule) if rule.is_a?(String)
        @uncountables.delete(replacement)
        @singulars.unshift([rule, replacement])
      end

      def uncountable(*words)
        @uncountables.add(words)
      end

      def human(rule, replacement)
        @humans.unshift([rule, replacement])
      end

      def irregular(singular, plural)
        @uncountables.delete(singular)
        @uncountables.delete(plural)

        s0 = singular[0]
        srest = singular[1..-1]

        p0 = plural[0]
        prest = plural[1..-1]

        if s0.upcase == p0.upcase
          plural(/(#{s0})#{srest}$/i, '\1' + prest)
          plural(/(#{p0})#{prest}$/i, '\1' + prest)

          singular(/(#{s0})#{srest}$/i, '\1' + srest)
          singular(/(#{p0})#{prest}$/i, '\1' + srest)
        else
          plural(/#{s0.upcase}#{srest}$/i,   p0.upcase   + prest)
          plural(/#{s0.downcase}#{srest}$/i, p0.downcase + prest)
          plural(/#{p0.upcase}#{prest}$/i,   p0.upcase   + prest)
          plural(/#{p0.downcase}#{prest}$/i, p0.downcase + prest)

          singular(/#{s0.upcase}#{srest}$/i,   s0.upcase   + srest)
          singular(/#{s0.downcase}#{srest}$/i, s0.downcase + srest)
          singular(/#{p0.upcase}#{prest}$/i,   s0.upcase   + srest)
          singular(/#{p0.downcase}#{prest}$/i, s0.downcase + srest)
        end
      end

      def clear(scope = :all)
        case scope
        when :all
          @plurals, @singulars, @uncountables, @humans = [], [], Uncountables.new, []
        else
          instance_variable_set "@#{scope}", []
        end
      end
    end

    def inflections(locale = :en)
      if block_given?
        yield Inflections.instance(locale)
      else
        Inflections.instance(locale)
      end
    end
  end
end
