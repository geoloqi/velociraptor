module Geoloqi

  ContentDirName = "content"
  ContentPath = File.join(Dir.getwd, ContentDirName)
  ContentDir = Dir.new(ContentPath)
 
  class MarkdownPlus < Redcarpet::Render::HTML

    def block_code(code, language)
      lang = language.blank? ? :html : language.to_sym
      highlighted = CodeRay.scan(code, lang).html
      "<pre><code class='CodeRay #{language}'>#{highlighted}</code></pre>"
    end

    def preprocess(text)
      text.gsub!(/^!\[:erb (.+)\]\(({(?:(?<!}\)).)+^})\)$/m) do
        template_path = File.join(ENV["PWD"], "views", $1+".erubis")
        if File.exists? template_path
          data = JSON.parse($2)
          template = Erubis::Eruby.new(File.read(template_path))
          template.result(data)
        else
          ""
        end
      end

      #Transform "[http://geoloqi.nclude Redcarpet::Render::SmartyPantscom]" into the markdown [geoloqi.com](http://geoloqi.com)
      text.gsub!(/\[(https?:\/\/([^\s]+))\]/, "[\\1](\\1)")

      #Transform "[/api/docs]" into the markdown [/api/docs](/api/docs)
      text.gsub!(/\[(\/[^\s]+)\]/, "[\\1](\\1)")

      #Transform Mediawiki "[http://geoloqi.com/api/docs API Docs]" into the markdown [API Docs](http://geoloqi.com/api/docs)
      # @TODO: For some reason this doesnt work on "https" links!
      text.gsub!(/\[(https?:\/\/[^\s]+) (.+?)\]/, "[\\2](\\1)")

      #Transform Mediawiki "[/api/docs API Docs]" into the markdown [API Docs](/api/docs)
      text.gsub!(/\[(\/[^\s]+)\ (.+?)\]/, "[\\2](\\1)")

      #Link Email Adresses
      text.gsub!(/(\S+@\S+.\S+)/, "[mailto:\\1](\\1)")

      #Link Twitter Usernames
      text.gsub!(/(?<=\s)@([a-z0-9_]+)/, "[@\\1](http://twitter.com/\\1)")

      #Vimeo
      text.gsub!(/^!\[:vimeo (\d+)x(\d+)\]\(([\d]+)\)$/, "<iframe src='http://player.vimeo.com/video/\\3' width='\\1' height='\\2' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>")

      #Youtube
      text.gsub!(/^!\[:youtube (\d+)x(\d+)\]\(([\w]+)\)$/, "<iframe width='\\1' height='\\2' src='http://www.youtube.com/embed/\\3' frameborder='0' allowfullscreen></iframe>")

      #Github Banner
      text.gsub!(/^!\[:github\]\(([\w\/-]+)\)$/, "<p class='github-banner'><a href='https://github.com/\\1'><img src='https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png' alt='Fork me on GitHub'></a></p>")

      text.gsub!(/!\[:markdown (\S+)?\]$/) do
        path = Geoloqi::Pages.path_for_slug $1
        unless path.nil?
          File.open(path, "r") do |file|
            markdown = file.read.gsub(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m, '')
            Geoloqi::Markdown.render(markdown) unless markdown.blank?
          end
        else
          ""
        end
      end

      # Section tags
      # a "bug?" in redcarpet is preventing this from working 
      # https://github.com/vmg/redcarpet/issues/13
      # https://github.com/vmg/redcarpet/issues/67
      #text.gsub!(/^!\[:section (\S+)\](?:\(?(\S+)\))?$(.+)^!\[:end\]$/m) do |section|
      #  id = $1.nil? ? "" : " id='#{$1}'"
      #  classes = $2.nil? ? "" : " class='#{$2}'"
      #  "<section#{id}#{classes}>#{$3}</section>"
      #end
      
      return text
    end

    def postprocess(text)
      # add id element to headers
      text.gsub!(/^(<h(2|3) ?(?!id)([\w-].+)?>(.+)<\/h\d>)$/) do |header|
        level = $2
        attrs = $3
        header_text = $4
        name = header_text.downcase().gsub(" ", "-")
        "<a id='#{name}' class='section-link'></a>\n\n<h#{level} data-section-name='#{name}' #{attrs}>#{header_text}</h#{level}>"
      end
      return text
    end
  end

  Markdown = Redcarpet::Markdown.new(Geoloqi::MarkdownPlus, {
    autolink: true,
    fenced_code_blocks: true
  })

  class Pages
    attr_reader :path, :body, :slug, :headers, :metadata, :tree

    def self.all directory=""
      slugs = []
      base = File.join(Geoloqi::ContentPath, directory)
      Dir.glob("#{base}/**/*.md").each do |path|
        unless(File.basename(path) =~ /^_/)
          slug = self.slug_for_path path
          slugs.push(slug)
        end
      end
      self.find slugs
    end

    # check to see if a slug exits
    def self.exists? slug
      path = self.path_for_slug(slug)
      unless path.nil?
        File.exists?(path)
      else
        false
      end    end

    # Get the slug for a given path
    def self.slug_for_path path
      path.chomp!(File.extname(path)).gsub!(/^.*#{Geoloqi::ContentPath}\//, "") if File.exists?(path)
    end
    
    # Gives the path for a given slug
    def self.path_for_slug slug
      pathA = File.join(Geoloqi::ContentPath, slug+".md")
      pathB = File.join(Geoloqi::ContentPath, slug, "index.md")
      if File.exists?(pathA)
        pathA
      elsif File.exists?(pathB)
        pathB
      else
        nil
      end
    end

    # Returns an array of pages for an array of slugs
    def self.find *slugs
      slugs = slugs.flatten
      count = slugs.count
      pages = slugs.collect do |slug|
        Geoloqi::Pages.new(slug) if self.exists? slug
      end
      if count == 1 && pages.count == 1
        pages.first  
      else 
        pages 
      end
    end

    def initialize(slug)
      @path = Geoloqi::Pages.path_for_slug slug
      @slug = slug
      unless @path.blank?
        File.open(@path, "r") do |file|
          content = file.read
          @metadata = Hashie::Mash.new(YAML::load(content.slice!(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)))
          @body = Geoloqi::Markdown.render(content)
          @tree = Nokogiri::HTML.parse @body
          @headers = @tree.css("h2,h3").collect do |header|
            Hashie::Mash.new({
              id: header.attributes["data-section-name"].value,
              text: header.content,
              tag: header.name
            })
          end
        end
      end
    end

    def title
      self.metadata.title
    end

    def template
      self.metadata.template.blank? ? nil : self.metadata.template.to_sym
    end

    def layout
      self.metadata.layout.blank? ? nil : self.metadata.layout.to_sym
    end

    def description
      self.metadata.description
    end

    def date
      DateTime.pase self.metadata.date
    end

    def last_modified
      File.mtime @path
    end

    def empty?
      @body.empty?
    end

    def exists?
      unless @path.blank?
        File.exists? @path
      else
        false
      end
    end
  end
end
