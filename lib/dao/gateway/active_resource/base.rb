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
        rescue ::ActiveResource::ResourceNotFound => e
          raise Dao::Gateway::RecordNotFound, e.message
        rescue ::ActiveResource::ConnectionError, Errno::ECONNREFUSED => e
          raise Dao::Gateway::BadConnection, e.to_s
        end

        def chain(scope, method_name, args, &block)
          scope.public_send(method_name, *args, &block)
        rescue ::ActiveResource::ResourceNotFound => e
          raise Dao::Gateway::RecordNotFound, e.message
        rescue ::ActiveResource::ResourceInvalid => e
          errors = if e.response.is_a?(source)
            e.response.errors.to_hash
          elsif e.response.body.present?
            source.format.decode(e.response.body)
          else
            {}
          end
          raise Dao::Gateway::InvalidRecord.new(errors)
        rescue ::ActiveResource::ForbiddenAccess => e
          raise Dao::Gateway::ForbiddenRecord, e.message
        rescue ::ActiveResource::ConnectionError, Errno::ECONNREFUSED => e
          raise Dao::Gateway::BadConnection, e.to_s
        end

        protected

        def export(domain, record = nil)
          return unless domain
          record ||= empty_record(domain)
          attributes = domain.attributes.except(*@black_list_attributes).stringify_keys

          record.attributes = attributes
          record
        end

        def collection_scope?(relation)
          relation.is_a?(::ActiveResource::Collection)
        end

        def empty_record(_domain)
          source.new
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
