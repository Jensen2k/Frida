'use strict';

/* Controllers */

angular.module('frida.controllers', [])
  .controller('DashboardController', ['$scope', '$http','socket','$window', function($scope, $http, socket, $window) {
    $scope.templateUrl = "partials/dashboard.html";
    $scope.temp = "..";
    $scope.update = function() {
      $http({method: 'GET', url: 'http://localhost:82/fridges/1/temp'}).
        success(function(data, status, headers, config) {
            console.log(data);
            $scope.temp = data.temp;                  //set view model

        }).
        error(function(data, status, headers, config) {
            $scope.apps = data || "Request failed";
            $scope.status = status;
        });

    };

    $scope.update();

    socket.on('groceries:update', function (message) {
        $scope.update();
    });
    socket.on('fridge:reset', function (message) {
        $window.location.reload()
    });

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

    $scope.delete = function(id, index) {
      console.log("click!");
      $scope.items.splice(index, 1);
      $http({method: 'DELETE', url: 'http://localhost:82/groceries/'+id}).
        success(function(data, status, headers, config) {
            console.log(data);
        }).
        error(function(data, status, headers, config) {
            $scope.apps = data || "Request failed";
            $scope.status = status;
        });
    };


    $scope.update = function() {
      $http({method: 'GET', url: 'http://localhost:82/groceries'}).
        success(function(data, status, headers, config) {

            data = data.groceries;
            console.log(data);

            $scope.items = data;                  //set view model
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

