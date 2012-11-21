define([
  "dojo/_base/declare",
  "dojo/_base/lang",
  "dojo/Evented"
], function(declare, lang, Evented) {
  console.log("Class");

  return declare("MyClass", [Evented], {
    constructor: function(options) {
      // default options
      var defaults = {};
      
      // mix args and defaults
      var settings = lang.mixin(defaults, options);
      
      // populate options
      declare.safeMixin(this, settings);
    },
    
    say: function(text){
      // send an event
      this.emit("say", text);

      //do stuff
      console.log(text);
    }
  });
});