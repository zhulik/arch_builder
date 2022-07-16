# frozen_string_literal: true

module Builder
  module HTTP
    def http_json_get(url) = JSON.parse(http_get(url), symbolize_names: true)

    def http_get(url) = Net::HTTP.get(URI.parse(url))

    def http_head(url)
      http = Net::HTTP.new(url.host, url.port)
      http.set_debug_output($stdout)
      http.request_head("#{url.path}?#{url.query}")
      # http = Net::HTTP.new(uri.host, uri.port)
      # response = http.request_head(uri.path + "?" + uri.query)
    end
  end
end
