module Assets
  def self.included(klass)
    klass.register Sinatra::AssetPack
    
    klass.assets {
      serve '/js',     from: 'assets/js'
      serve '/css',    from: 'assets/css'
      serve '/images', from: 'assets/img'
      
      # Setup a bundle of Javascript      
      js :main_js, [
        #'/js/plugin.js',
        #'/js/application.js'
      ]

      # Setup a bundle of CSS
      css :main_css, [
        #'/css/reset.css',
        #'/css/style.css'
      ]
      
      # Set Compressors
      js_compression  :yui, :munge => true
      css_compression :sass

      # Prebuild assets in prodctions
      #prebuild ENV['RACK_ENV'] == 'production'
    }
  end
end