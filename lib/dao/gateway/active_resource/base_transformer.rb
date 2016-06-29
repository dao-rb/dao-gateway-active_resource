module Dao
  module Gateway
    module ActiveResource
      class BaseTransformer < Dao::Gateway::ScopeTransformer
        def many(relation)
          super(relation)
        end

        def one(relation)
          super(Array(relation))
        end

        private

        def transform(relation)
          super(relation) do |record|
            collect_attributes(record)
          end
        end

        def collect_attributes(record)
          HashWithIndifferentAccess.new(record.try(:serializable_hash))
        end
      end
    end
  end
end
