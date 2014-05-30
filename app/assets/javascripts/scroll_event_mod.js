$(document).ready(function(){
  var oniPhone = function(){
    console.log("oniPhone");
    var timer = null;
    var pre_scroll_top = $(window).scrollTop();
    console.log("oniPhone line6: " + pre_scroll_top);
    var scrolling = false;
    $(window).bind("touchstart", function(){
      clearTimeout(timer);
      pre_scroll_top = $(window).scrollTop();
    });
    $(window).bind("touchmove", function(){
      clearTimeout(timer);
      if(scrolling){
        $(window).trigger("scrollmove", []);
      }else{
        if(Math.abs($(window).scrollTop() - pre_scroll_top) >= 5){
          $(window).trigger("scrollstart", []);
          scrolling = true;
        };
      };
    });
    $(window).bind("scroll", function(){
      if(!scrolling){
        return;
      }
      clearTimeout(timer);
      timer = setTimeout(function(){
        scrolling = false;
        $(window).trigger("scrollend", []);
      }, 300);
    });
  };
  
  var onAndroid = function(){
    var timer = null;
    var user_operation = false;
    var androidScroll = function(){
      if(!user_operation){
        return;
      }
      if(timer == null){
        $(window).trigger("scrollstart", []);
      }else{
        $(window).trigger("scrollmove", []);
      };
      clearTimeout(timer);
      timer = setTimeout(function(){
        user_operation = false;
        timer = null;
        $(window).trigger("scrollend", []);
      }, 300);
    };
    var userOperationOn = function(){
      user_operation = true;
    };
    var userOperationOff = function(){
      user_operation = false;
    };
    $(window).bind("scroll", androidScroll);
    $(window).bind("touchstart", userOperationOn);
    $(window).bind("touchend", userOperationOff);
  };
  
  var ua = navigator.userAgent;
  if(ua.indexOf("iPhone") != -1){
    console.log("your device  iPhone");
    oniPhone();
  }else if(ua.indexOf("Android") != -1){
    onAndroid();
  }
  
  $(window).bind("scrollstart", function(e){console.log(e.type);});
  $(window).bind("scrollmove", function(e){console.log(e.type);});
  $(window).bind("scrollend", function(e){console.log(e.type);});
});