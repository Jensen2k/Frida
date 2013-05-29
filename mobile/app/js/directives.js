'use strict';

/* Directives */
angular.module('frida.directives', []).
/*
directive('appBlock', function() {
  return function(scope, elm, attrs) {
    var height = $(document).height();
    var width = $(document).width();
    elm.height(height);
    elm.width(width);
  };
}).
directive('appBlockholder', function() {
 return function(scope, elm, attr) {
  var width = $(document).width()+15;
  elm.width(elm.find("> div").length*width);
  $(".app").width(width);
  elm.css({left: -width});
}
}).*/
directive('appNodelay', function() {
  return function(scope, element, attrs) {
    var tapping;
    tapping = false;
    element.bind('touchstart', function() {
      tapping = true;
      return tapping;
    });
    element.bind('touchmove', function() {
      tapping = false;
      return tapping;
    });
    return element.bind('touchend', function() {
      if (tapping) {
        return scope.$apply(attrs['gfTap']);
      }
    });
  };
}).
directive('appTime', function() {

  function update(elm) {
    setTimeout(function() {

      var currDate = new Date();
      var time = currDate.getHours() + ":" + ( (currDate.getMinutes()<10?'0':'') + currDate.getMinutes() ) + ":" + ( (currDate.getSeconds()<10?'0':'') + currDate.getSeconds() );
      elm.text(time);
      update(elm);
  }, 500);
  }

 return function(scope, elm, attr) {

  update(elm);

}
})./*.directive('menuElement', function() {
  return {
    link: function(scope, elm, attrs) {
      elm.bind('click', function() {
          var width = $(document).width()+15;
        $(".views").animate({
          left: "0px"
        });
        $(".sidebar").animate({
          left: width-74+"px"
        });
      });
    }
  };
}).
*/
directive('appDate', function() {
 return function(scope, elm, attr) {
  var monthNames = [ "Januar", "Februar", "Mars", "April", "Mai", "Juni",
  "Juli", "August", "September", "Oktober", "November", "Desember" ];
  var currDate = new Date();
  var date = currDate.getDate() + ". " + monthNames[currDate.getMonth()];
  elm.text(date);
}
});
