'use strict';


// Declare app level module which depends on filters, and services
angular.module('frida', ['frida.filters', 'frida.services', 'frida.directives', 'frida.controllers']).
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/',
    	{
    		controller: 'DashboardController',
    		templateUrl: 'partials/dashboard.html'
    	});
    $routeProvider.when('/dashboard',
        {
            controller: 'DashboardController',
            templateUrl: 'partials/dashboard.html'
        });
    $routeProvider.when('/fridge',
    	{
    		controller: 'FridgeController',
    		templateUrl: 'partials/fridge.html'
    	});
    $routeProvider.when('/list',
    	{
    		controller: 'ListController',
    		templateUrl: 'partials/list.html'
    	});
    $routeProvider.when('/stats',
    	{
    		controller: 'StatsController',
    		templateUrl: 'partials/stats.html'
    	});
    $routeProvider.when('/settings',
    	{
    		controller: 'SettingsController',
    		templateUrl: 'partials/settings.html'
    	});
    $routeProvider.otherwise({redirectTo: '/'});
  }]);
