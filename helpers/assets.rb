class Application < Sinatra::Base
  helpers do
    def add_header_js(*javascripts)
      @_head_javascript ||= []
      @_head_javascript += javascripts
    end
    
    def add_js(*javascripts)
      @_foot_javascript ||= []
      @_foot_javascript += javascripts
    end

    def add_css *stylesheets
      @_css ||= []
      @_css += stylesheets
    end

    def include_js position = :footer
      @_foot_javascript ||= []
      @_head_javascript ||= []
      extra_javascript = ""
      javascripts = (position == :head) ? @_head_javascript : @_foot_javascript
      unless javascripts.to_a.empty?
        javascripts.each do |script|
          if script.match(/^http(|s):\/\//)
            extra_javascript += "<script src='#{javascript}'></script>"
          elsif script.match(/<script/)
            extra_javascript += "<script>#{javascript}</script>"
          else
            extra_javascript += "<script src='#{javascript_path script}'></script>"
          end
        end
      end
      extra_javascript
    end

    def include_css
      extra_stylesheets = ""
      unless @_css.to_a.empty?
        
        @_css.each do |stylesheet|
          if stylesheet.match(/^http(|s):\/\//)
            extra_stylesheets += "<link rel='stylesheet' href='#{stylesheet}'>"
          elsif stylesheet.match(/<script/)
            extra_stylesheets += "<style>#{stylesheet}</style>"
          else
            extra_stylesheets += "<link rel='stylesheet' href='#{stylesheet_path stylesheet}'>"
          end
        end

      end
      extra_stylesheets
    end

  end
end