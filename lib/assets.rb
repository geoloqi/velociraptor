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
      css :screen, [
        '/css/screen.css'
      ]

      css :print, [
        '/css/print.css'
      ]
      
      css :id, [
        '/css/ie.css'
      ]
      
      # Set Compressors
      js_compression  :jsmin
      css_compression :sass

      # Prebuild assets in prodctions
      prebuild ENV['RACK_ENV'] == 'production'
    }
  end
end