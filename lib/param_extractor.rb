require_relative './obj'

module Filterparams
  class ParamExtractor
    FILTER_MATCHES = /filter\[param\]\[(?<name>\w+)\]
                      (\[(?<filter>\w+)\](\[(?<alias>\w+)\])?)?/x

    def initialize(params)
      @params = params
    end

    def params
      match_hashes.map { |map| generate_param map }
    end

    def params_hash
      filter_args = params.map do |parameter|
        [parameter.identification, parameter]
      end.flatten
      Hash[*filter_args]
    end

    private

    def generate_param(param_hash)
      Filterparams::Parameter.new(param_hash[:name], param_hash)
    end

    def match_hashes
      matches = @params.map do |key, value|
        if value.is_a? Array
          value = if value.size > 0
                    value[0]
                  else
                    nil
                  end
        end

        {
          match: FILTER_MATCHES.match(key),
          value: value
        }
      end
      matches = matches.reject { |map| map[:match].nil? }
      matches.map do |map|
        create_match_lookup(map)
      end
    end

    def create_match_lookup(map)
      match = map[:match]
      {
        name: match['name'],
        value: map[:value],
        filter: match['filter'],
        alias: match['alias']
      }
    end
  end
end
