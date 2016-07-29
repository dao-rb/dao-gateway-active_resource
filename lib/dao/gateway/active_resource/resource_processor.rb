module Dao
  module Gateway
    module ActiveResource
      class ResourceProcessor < Gateway::Processor
        def process(record)
          HashWithIndifferentAccess.new(record.try(:serializable_hash))
        end
      end
    end
  end
end
