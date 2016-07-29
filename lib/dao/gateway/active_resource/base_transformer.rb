module Dao
  module Gateway
    module ActiveResource
      class BaseTransformer < Dao::Gateway::ScopeTransformer
        def add_processors
          pipe.preprocess(ResourceProcessor.new)
        end
      end
    end
  end
end
