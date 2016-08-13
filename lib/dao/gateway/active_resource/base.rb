module Dao
  module Gateway
    module ActiveResource
      class Base < Dao::Gateway::Base
        def save!(domain, _)
          record = export(domain, record(domain))
          record.save!

          domain.attributes = import(record, domain.initialized_with).attributes
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

        def collection_scope?(relation)
          relation.is_a?(::ActiveResource::Collection)
        end

        def record(domain)
          source.find(domain.id) if domain.id.present?
        rescue ::ActiveResource::ResourceNotFound
          nil
        end
      end
    end
  end
end
