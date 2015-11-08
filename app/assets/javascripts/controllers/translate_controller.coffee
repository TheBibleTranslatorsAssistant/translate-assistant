controller = ($http, $scope) ->
  # Load words from the server
  $http({
    method: 'GET',
    url:    '/words'
  }).success (response) ->
    $scope.words = response

  $scope.startWordIndex = null
  $scope.startWith = (word, $event) ->
    $scope.startWordIndex = $scope.words.indexOf(word)
    $scope.endWordIndex = $scope.startWordIndex
    $event.stopPropagation()

  $scope.endWordIndex = null
  $scope.endWith = (word, $event) ->
    # Don't change end word if mouse isn't pressed
    return unless $event.which == 1
    $scope.endWordIndex = $scope.words.indexOf(word)
    $event.stopPropagation()

  $scope.indexIsHighlighted = (index) ->
    return false if $scope.startWordIndex == null or $scope.endWordIndex == null
    min = Math.min($scope.startWordIndex, $scope.endWordIndex)
    max = Math.max($scope.startWordIndex, $scope.endWordIndex)
    index >= min and index <= max

  $scope.clearHighlight = ->
    $scope.startWordIndex = null
    $scope.endWordIndex = null

  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()

angular
  .module 'translateAssistant'
  .controller 'TranslateController', [
    '$http'
    '$scope'
    controller
  ]

