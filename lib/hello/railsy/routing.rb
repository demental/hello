module Hello
  module Railsy
    module Routing

      def constraints_scope(lamb, &block)
        scope constraints: lamb do
          yield
        end
      end

      def authenticated(&block)
        scope constraints: -> (r) { r.env['hello'].signed_in? } do
          yield
        end
      end

      def not_authenticated(&block)
        scope constraints: -> (r) { !r.env['hello'].signed_in? } do
          yield
        end
      end

      def current_user(lamb, &block)
        x = Awesome.new(lamb)
        scope constraints: x do
          yield
        end
      end

      class Awesome
        def initialize(lamb)
          @lamb = lamb
        end

        def matches?(r)
          @lamb.call(r.env['hello'].current_user)
        end
      end

    end
  end
end

if defined? ActionDispatch::Routing::Mapper
  ActionDispatch::Routing::Mapper.class_eval do
    include Hello::Railsy::Routing
  end
end
