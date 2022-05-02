module Seiten::Errors
  class RoutingError < BaseError
    def backtrace
      []
    end
  end
end
