#= require angular.min

KuiperApp = angular.module("kuiper", [])

KuiperApp.config ($routeProvider) ->
  $routeProvider.when "/sites", { templateUrl: "assets/sites/layout.html", controller: SitesController }
  $routeProvider.otherwise { redirectTo: "/sites" }

#= require_tree ./controllers
