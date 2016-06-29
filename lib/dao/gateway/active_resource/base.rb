module Dao
  module Gateway
    module ActiveResource
      class Base < Dao::Gateway::Base
        def map(object, _)
          import(object)
        end

        def save!(domain, _)
          record = export(domain, record(domain.id))
          record.save!

          domain.attributes = import(record).attributes
          domain
        rescue ::ActiveResource::ResourceInvalid
          raise Dao::Gateway::InvalidRecord.new(record.errors.to_hash)
        end

        def chain(scope, method_name, args, &block)
          scope.public_send(method_name, *args, &block)
        rescue ::ActiveResource::ResourceNotFound => e
          raise Dao::Gateway::RecordNotFound, e.message
        end

        protected

        def export(base, record = nil)
          return unless base
          record ||= source.new
          attributes = base.attributes.except(*@black_list_attributes).stringify_keys

          record.attributes = attributes
          record
        end

        def import(relation)
          unless relation.nil?
            if relation.is_a?(::ActiveResource::Collection)
              @transformer.many(relation)
            elsif relation.is_a?(source)
              @transformer.one(relation)
            else
              @transformer.other(relation)
            end
          end
        end

        def record(domain_id)
          source.find(domain_id) if domain_id.present?
        rescue ::ActiveResource::ResourceNotFound
          nil
        end
      end
    end
  end
end
