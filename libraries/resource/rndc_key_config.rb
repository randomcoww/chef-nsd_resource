class ChefNsdResource
  class Resource
    class RndcKeyConfig < Chef::Resource
      include NsdResourceHelper
      include Dbag

      resource_name :nsd_resource_rndc_key_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]

      property :rndc_keys_data_bag, String
      property :rndc_keys_data_bag_item, String
      property :rndc_key_names, Array, default: []
      property :key_options, Hash, default: {}

      property :content, String, default: lazy { to_conf }
      property :path, String

      private

      def to_conf
        rndc_keys = []

        keys_resource = Dbag::Keystore.new(
          rndc_keys_data_bag,
          rndc_keys_data_bag_item,
        )
        rndc_key_names.sort.each do |k|
          rndc_keys << {
            'name' => k,
            'secret' => keys_resource.get_or_create(k, SecureRandom.base64)
          }.merge(key_options)
        end

        ConfigGenerator.generate_from_hash({'key' => rndc_keys})
      end
    end
  end
end
