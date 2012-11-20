require([
  '/assets/class.js'
], function(MyClass){
  console.log("Application");
  
  thing = new MyClass();
  
  console.log(thing);
  
  thing.on("say", function(text){
    console.log("thing said " + text);
  });

  thing.say("hello");
});