module NsdResourceHelper

  class ConfigGenerator
    ## convert hash to yaml like config that unbound and nsd use

    ## sample source config
    # {
    #   :server => {
    #     :interface => [
    #       'if1',
    #       'if2'
    #     ],
    #     'interface-automatic' => true,
    #     :port => 53
    #   },
    #   'remote-control' => {
    #     'control-enable' => true
    #   },
    #   :zone => [
    #     {
    #       :name => 'z1',
    #       :zonefile => 'z1file'
    #     },
    #     {
    #       :name => 'z2',
    #       :zonefile => 'z2file'
    #     },
    #     {
    #       :name => 'z3',
    #       :zonefile => 'z3file'
    #     }
    #   ]
    # }

    def self.generate_from_hash(config_hash)
      g = new
      out = []

      config_hash.each do |k, v|
        g.parse_config_object(out, k, v, '')
      end
      return out.join($/)
    end

    def parse_config_object(out, k, v, prefix)
      case v
      when Hash
        out << [prefix, k, ':'].join
        v.each do |e, f|
          parse_config_object(out, e, f, prefix + '  ')
        end

      when Array
        v.each do |e|
          parse_config_object(out, k, e, prefix)
        end

      when String,Integer
        out << [prefix, k, ': ', v].join

      when TrueClass
        out << [prefix, k, ': ', 'yes'].join

      when FalseClass
        out << [prefix, k, ': ', 'no'].join
      end
    end
  end
end
