require "cgi"

module ApiTie
  module ToQuery
    refine Object do
      def to_param
        to_s
      end

      def to_query(key)
        "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
      end
    end

    refine Hash do
      def to_query(namespace = nil)
        collect do |key, value|
          unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
            value.to_query(namespace ? "#{namespace}[#{key}]" : key)
          end
        end.compact.sort! * '&'
      end
    end
  end
end
