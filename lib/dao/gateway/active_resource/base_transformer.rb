module Dao
  module Gateway
    module ActiveResource
      class BaseTransformer < Dao::Gateway::ScopeTransformer
        def one(relation)
          super(Array(relation))
        end

        private

        def add_processors
          @processors.unshift ResourceProcessor.new
        end
      end
    end
  end
end
