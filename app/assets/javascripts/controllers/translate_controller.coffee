controller = ($scope) ->
  $scope.foo = "bar"

angular
  .module 'translateAssistant'
  .controller 'TranslateController', [
    '$scope'
    controller
  ]

