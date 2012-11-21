class Application < Sinatra::Base
  helpers do

    def checked_if(boolean)
      boolean == true ? 'checked' : ''
    end

    def selected_if(boolean)
      boolean == true ? 'selected' : ''
    end

    def title(*value)
      @_title = "#{value.first} - #{Application.Config.title}" 
    end

    def full_title(*value); 
      @_full_title = value.first
    end

    def page_title
      if(!@_full_title.blank?)
        "<title>#{@_full_title}</title>"
      elsif !@_title.blank?
        "<title>#{@_title} - #{Application.Config.title}</title>"
      else
        "<title>#{Application.Config.title}</title>"
      end
    end

    def description(*value)
      unless value.empty?
        @_description = value.first
      else
        "<meta name='description' content='#{@_description}'>"
      end
    end

    def mobile_view(bool) 
      @_mobile = bool || false 
    end

    def viewport
      '<meta name="viewport" content="width=device-width,initial-scale=1">' if @_mobile
    end
    
    def partial(page, options={})
      erubis page, options.merge!(:layout => false)
    end
    
    def current_page?(*matches)
      matches.include? request.path
    end

    def path_class
      classes = request.path.split('/')
      classes.push(" root") if request.path == '/'
      classes.join(" ")
    end

    def current_page(*matches)
      "active" if matches.include? request.path
    end
  end
end