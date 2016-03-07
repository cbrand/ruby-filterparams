require_relative './obj'

module Filterparams
  class ParamExtractor
    FILTER_MATCHES = /filter\[param\]\[(?<name>\w+)\](\[(?<filter>\w+)\](\[(?<alias>\w+)\])?)?/

    def initialize(params)
      @params = params
    end

    def params
      matches = @params.map do |key, value|
        {
          match: FILTER_MATCHES.match(key),
          value: value,
        }
      end
      matches = matches.select { |map| !map[:match].nil? }
      matches = matches.map do |map|
          match = map[:match]
          {
            name: match['name'],
            value: map[:value],
            filter: match['filter'],
            alias: match['alias'],
          }
      end
      matches.map { |map| generate_param map }
    end

    def params_hash
      filter_args = params.map {
        |parameter| [parameter.identification, parameter]
      }.flatten
      Hash[ *filter_args ]
    end

    private
    def generate_param(param_hash)
      Filterparams::Parameter.new(param_hash[:name], param_hash)
    end

  end
end
