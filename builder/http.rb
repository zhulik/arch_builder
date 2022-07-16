# frozen_string_literal: true

Faraday.default_connection_options = Faraday::ConnectionOptions.new(
  timeout: 2,
  open_timeout: 2
)

module Builder
  module HTTP
    def http_json_get(url) = JSON.parse(http_get(url), symbolize_names: true)

    def http_get(url) = Faraday.get(url).body

    def http_head(url)
      Faraday.head(url)
    end
  end
end
