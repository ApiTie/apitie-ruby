require "forwardable"

module ApiTie
  class Body < ClosedStruct
    extend Forwardable

    def_delegators :@contents, :fetch
    def_delegators :data, :empty?

    def method_missing(name, *args, &block)
      if has_type?(name)
        access name, from: "data"
      else
        super
      end
    end

    private

    def has_type?(name)
      return false if empty?

      data.any? { |record| record.fetch("type") == name.to_s }
    end

    def access(name, from:)
      klass = find_or_bootstrap_klass(name)
      fetch(from)
        .select { |item| item.fetch("type") == name.to_s }
        .map(&klass.method(:new))
    end

    def find_or_bootstrap_klass(name)
      Record.const_get(name.to_s.capitalize)
    rescue NameError => e
      Record.const_set(name.capitalize, Class.new(Record))
    end
  end
end
