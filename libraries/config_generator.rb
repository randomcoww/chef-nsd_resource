module ConfigGenerator
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

  def generate_config(config_hash)
    out = []

    config_hash.each do |k, v|
      parse_config_object(out, k, v, '')
    end
    return out.join($/)
  end

  def parse_config_object(out, k, v, prefix)
    if v.is_a?(Hash)
      out << [prefix, k, ':'].join
      v.each do |e, f|
        parse_config_object(out, e, f, prefix + '  ')
      end

    elsif v.is_a?(Array)
      v.each do |e|
        parse_config_object(out, k, e, prefix)
      end

    elsif v.is_a?(String) || v.is_a?(Integer)
      out << [prefix, k, ': ', v].join

    elsif v.is_a?(TrueClass)
      out << [prefix, k, ': ', 'yes'].join

    elsif v.is_a?(FalseClass)
      out << [prefix, k, ': ', 'no'].join
    end
  end
end
