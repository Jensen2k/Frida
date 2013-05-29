'use strict';

/* Controllers */

angular.module('frida.controllers', [])
  .controller('DashboardController', ['$scope', function($scope) {
    $scope.templateUrl = "partials/dashboard.html";
  	$scope.turtle = "Hello, Tony and fuck!";
  	$scope.shell = "Eirik is a douche";
  	console.log(this);
  }])
  .controller('FridgeController', ['$scope', '$http', 'socket', function($scope, $http, socket) {
  	$scope.turtle = "Overview";
  	$scope.shell = "Show's the content for the overview";
    $scope.refresh = function() {
      $scope.update();
    };
    console.log(socket);
    socket.on('connection', function (data) {
      console.log("Init: ");
      console.log(data);
    });

    socket.on('groceries:update', function (message) {
      $scope.update();
    });

    $scope.update = function() {
      $http({method: 'GET', url: 'http://localhost:3000/groceries'}).
        success(function(data, status, headers, config) {

            var items = [];
            var currArr = [];
            var count = 0;
            for(var i = 0; i < data.length; i++) {
              if(count > 1) {
                items.push(currArr);
                currArr = [];
                count = 0;
              }
              currArr.push(data[i]);
              count++;
            }
            if(currArr.length != 0) {
              items.push(currArr);
            }

            console.log(items);

            $scope.items = items;                  //set view model
            console.log(data);
        }).
        error(function(data, status, headers, config) {
            $scope.apps = data || "Request failed";
            $scope.status = status;
        });
    };

          $scope.update();



  }])
  .controller('MainCtrl', ['$scope', function($scope) {
    $scope.action = function() {
      console.log("Test!");
    }
  }]).controller('ListController', ['$scope', function($scope) {

  }]).controller('StatsController', ['$scope', function($scope) {

  }]).controller('SettingsController', ['$scope', function($scope) {

  }]).
  controller('Menu', ['$scope', '$location', function($scope, $location) {
    console.log($location.path());
    $scope.getClass = function(path) {
      if ($location.path().substr(0, path.length) == path) {
        return "active"
      } else {
        return ""
      }
    }

  }]);
