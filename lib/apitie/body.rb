require "forwardable"

module ApiTie
  class Body < ClosedStruct
    extend Forwardable

    def_delegators :@contents, :empty?
  end
end
