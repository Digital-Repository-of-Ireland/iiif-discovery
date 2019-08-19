require 'active_support/core_ext/class/subclasses'
require 'active_support/ordered_hash'
require 'active_support/inflector'
require 'json'
require 'iiif/presentation'

module IIIF
  module Discovery
    class Service < IIIF::Service

      def type_only_keys; {}; end

      def initialize(hsh={})
        super
        self.define_methods_for_hash_only_keys
        self.define_methods_for_type_only_keys
        self.snakeize_keys
      end

      # Static methods / alternative constructors
      class << self
        # Parse from a file path, string, or existing hash
        def parse(s)
          ordered_hash = nil
          if s.kind_of?(String) && File.exists?(s)
            ordered_hash = IIIF::OrderedHash[JSON.parse(IO.read(s))]
          elsif s.kind_of?(String) && !File.exists?(s)
            ordered_hash = IIIF::OrderedHash[JSON.parse(s)]
          elsif s.kind_of?(Hash)
            ordered_hash = IIIF::OrderedHash[s]
          else
            m = '#parse takes a path to a file, a JSON String, or a Hash, '
            m += "argument was a #{s.class}."
            if s.kind_of?(String)
              m+= "If you were trying to point to a file, does it exist?"
            end
            raise ArgumentError, m
          end
          return IIIF::Discovery::Service.from_ordered_hash(ordered_hash)
        end
      end

      def validate
        # TODO:
        # * check for required keys
        # * type check Array-only values
        # * type check String-only values
        # * type check Integer-only values
        # * type check AbstractResource-only values
        self.required_keys.each do |k|
          unless self.has_key?(k)
            m = "A(n) #{k} is required for each #{self.class}"
            raise IIIF::Discovery::MissingRequiredKeyError, m
          end
        end
      end

      def self.from_ordered_hash(hsh, default_klass=IIIF::OrderedHash, force_default_klass=false)
        # Create a new object (new_object)
        type = nil

        if force_default_klass
          type = default_klass
        else
          if hsh.has_key?('type')
            type = IIIF::Discovery::Service.get_descendant_class_by_jld_type(hsh['type'])
          end
        end
        new_object = type.nil? ? default_klass.new : type.new

        hsh.keys.each do |key|
          key = key.to_s
          new_key = key.underscore == key ? key : key.underscore

          if hsh[key].kind_of?(Hash)
            new_object[new_key] = from_hash(new_object, new_key, hsh[key])
          elsif hsh[key].kind_of?(Array)
            new_object[new_key] = []
            hsh[key].each do |member|
              if member.kind_of?(Hash)
                new_object[new_key] << from_hash(new_object, new_key, member)
              else
                new_object[new_key] << member
                # Again, no nested arrays, right?
              end
            end
          else
            new_object[new_key] = hsh[key]
          end
        end
        new_object
      end

      protected

      def self.from_hash(new_object, new_key, value)
        if new_object.type_only_keys.key?(new_key)
          IIIF::Discovery::Service.from_ordered_hash(
                                      value,
                                      new_object.type_only_keys[new_key],
                                      true
          )
        else
          IIIF::Discovery::Service.from_ordered_hash(value)
        end
      end

      def define_methods_for_type_only_keys
        type_only_keys.keys.each do |key|
          next if array_only_keys.include? key

          # Setters
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(type_only_keys[key])
              m = "#{key} must be an #{type_only_keys[key]}."
              raise IIIF::Discovery::IllegalValueError, m
            end

            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(type_only_keys[key])
                m = "#{key} must be an #{type_only_keys[key]}."
                raise IIIF::Discovery::IllegalValueError, m
              end

              self.send('[]=', key, arg)
            end
          end
          # Getters
          define_singleton_method(key) do
            self.send('[]', key)
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def define_methods_for_array_only_keys
        array_only_keys.each do |key|
          # Setters
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(Array)
              m = "#{key} must be an Array."
              raise IIIF::Discovery::IllegalValueError, m
            end

            if type_only_keys.key?(key) && arg.any?{ |a| !a.kind_of?(type_only_keys[key]) }
                m = "#{key} must be an Array of #{type_only_keys[key]}."
                raise IIIF::Discovery::IllegalValueError, m
            end

            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(Array)
                m = "#{key} must be an Array."
                raise IIIF::Discovery::IllegalValueError, m
              end

              if type_only_keys.key?(key) && arg.any?{ |a| !a.kind_of?(type_only_keys[key]) }
                m = "#{key} must be an Array of #{type_only_keys[key]}."
                raise IIIF::Discovery::IllegalValueError, m
              end

              self.send('[]=', key, arg)
            end
          end
          # Getters
          define_singleton_method(key) do
            self[key] ||= []
            self[key]
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def define_methods_for_abstract_resource_only_keys
        # keys in this case is an array of hashes with { key: 'k', type: Class }
        abstract_resource_only_keys.each do |hsh|
          key = hsh[:key]
          type = hsh[:type]
          # Setters
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(type)
              m = "#{key} must be an #{type}."
              raise IIIF::Discovery::IllegalValueError, m
            end
            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(type)
                m = "#{key} must be an #{type}."
                raise IIIF::Discovery::IllegalValueError, m
              end
              self.send('[]=', key, arg)
            end
          end
          # Getters
          define_singleton_method(key) do
            self[key] ||= []
            self[key]
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def define_methods_for_string_only_keys
        string_only_keys.each do |key|
          # Setter
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(String)
              m = "#{key} must be an String."
              raise IIIF::Discovery::IllegalValueError, m
            end
            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(String)
                m = "#{key} must be an String."
                raise IIIF::Discovery::IllegalValueError, m
              end
              self.send('[]=', key, arg)
            end
          end
          # Getter
          define_singleton_method(key) do
            self[key] ||= []
            self[key]
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def define_methods_for_hash_only_keys
        hash_only_keys.each do |key|
          # Setter
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(Hash)
              m = "#{key} must be a Hash."
              raise IIIF::Discovery::IllegalValueError, m
            end
            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(Hash)
                m = "#{key} must be a Hash."
                raise IIIF::Discovery::IllegalValueError, m
              end
              self.send('[]=', key, arg)
            end
          end
          # Getter
          define_singleton_method(key) do
            self[key] ||= []
            self[key]
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def define_methods_for_int_only_keys
        int_only_keys.each do |key|
          # Setter
          define_singleton_method("#{key}=") do |arg|
            unless arg.kind_of?(Integer) && arg > 0
              m = "#{key} must be a positive Integer."
              raise IIIF::Discovery::IllegalValueError, m
            end
            self.send('[]=', key, arg)
          end
          if key.camelize(:lower) != key
            define_singleton_method("#{key.camelize(:lower)}=") do |arg|
              unless arg.kind_of?(Integer) && arg > 0
                m = "#{key} must be a positive Integer."
                raise IIIF::Discovery::IllegalValueError, m
              end
              self.send('[]=', key, arg)
            end
          end
          # Getter
          define_singleton_method(key) do
            self[key] ||= []
            self[key]
          end
          if key.camelize(:lower) != key
            define_singleton_method(key.camelize(:lower)) do
              self.send('[]', key)
            end
          end
        end
      end

      def self.get_descendant_class_by_jld_type(type)
        IIIF::Discovery::Service.all_service_subclasses.find do |klass|
          klass.const_defined?(:TYPE) && klass.const_get(:TYPE).include?(type)
        end
      end

      # All known subclasses of service.
      def self.all_service_subclasses
        @all_service_subclasses ||= IIIF::Discovery::Service.descendants.reject(&:singleton_class?)
      end

    end
  end
end
