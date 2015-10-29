require 'spec_helper'

module RemoveMethodTests
  class A
    def do_something
      return 1
    end
  end
end

describe Module do
  describe '#delegate' do
    context 'single method' do
      let(:delegator_klass) do
        Struct.new(:something) do
          delegate :foo, to: :something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.foo }

      it { is_expected.to eq 42 }
    end

    context 'instance variable' do
      let(:delegator_klass) do
        Class.new do
          def initialize(something)
            @something = something
          end

          delegate :foo, to: :@something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.foo }

      it { is_expected.to eq 42 }
    end

    context 'inherited instance variable' do
      let(:base_klass) {
        Class.new do
          def initialize(something)
            @something = something
          end
        end
      }

      let(:delegator_klass) do
        bk = base_klass
        Class.new(bk) do
          delegate :foo, to: :@something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.foo }

      it { is_expected.to eq 42 }
    end

    context 'inherited method' do
      let(:base_klass) {
        Class.new do
          attr_reader :something

          def initialize(something)
            @something = something
          end
        end
      }

      let(:delegator_klass) do
        bk = base_klass
        Class.new(bk) do
          delegate :foo, to: :something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.foo }

      it { is_expected.to eq 42 }
    end

    context 'singleton class' do
      let(:delegator_klass) do
        Class.new do
          def self.config
            'foobar'
          end

          class << self
            delegate :length, to: :config
          end
        end
      end

      subject { delegator_klass.length }

      it { is_expected.to eq 6 }
    end

    context 'multiple calls' do
      let(:delegator_klass) do
        Struct.new(:something, :else) do
          delegate :foo, to: :something
          delegate :bar, to: :else
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo, :bar)
      end

      let(:delegatee_instance1) { delegatee_klass.new 42, 43 }
      let(:delegatee_instance2) { delegatee_klass.new 44, 45 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance1, delegatee_instance2) }

      it { expect(delegator_instance.foo).to eq 42 }
      it { expect(delegator_instance.bar).to eq 45 }
    end

    context 'multiple at once' do
      let(:delegator_klass) do
        Struct.new(:something) do
          delegate :foo, :bar, to: :something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo, :bar)
      end

      let(:delegatee_instance) { delegatee_klass.new 42, 43 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      it { expect(delegator_instance.foo).to eq 42 }
      it { expect(delegator_instance.bar).to eq 43 }
    end

    context 'prefixes' do
      let(:delegator_klass) do
        Struct.new(:something) do
          delegate :foo, to: :something, prefix: true
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.something_foo }

      it { is_expected.to eq 42 }
    end

    context 'nil method' do
      let(:delegator_klass) do
        Struct.new(:something) do
          delegate :foo, to: :something
        end
      end

      let(:delegator_instance) { delegator_klass.new(nil) }

      subject { lambda { delegator_instance.foo } }

      it { is_expected.to raise_error DelegationError }
    end

    context 'allow nil' do
      let(:delegator_klass) do
        Struct.new(:something) do
          delegate :foo, to: :something, allow_nil: true
        end
      end

      let(:delegator_instance) { delegator_klass.new(nil) }

      subject { delegator_instance.foo }

      it { is_expected.to be_nil }
    end

    context 'method_missing defined on delegator' do
      let(:delegator_klass) do
        Struct.new(:something) do
          def method_missing(name, *args, &block)
            raise 'should not end up here'
          end

          delegate :foo, to: :something
        end
      end

      let(:delegatee_klass) do
        Struct.new(:foo)
      end

      let(:delegatee_instance) { delegatee_klass.new 42 }
      let(:delegator_instance) { delegator_klass.new(delegatee_instance) }

      subject { delegator_instance.foo }

      it { is_expected.to eq 42 }
    end

    context 'send redefined on delegator' do
      pending 'write this'
    end
  end
end
