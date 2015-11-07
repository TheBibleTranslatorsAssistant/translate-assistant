controller = ($scope) ->
  $scope.words = [
    {"id":1,"word":"A man","word_index":1,"concept_id":null},
    {"id":2,"word":"named","word_index":2,"concept_id":null},
    {"id":3,"word":"Elimelech","word_index":3,"concept_id":null},
    {"id":4,"word":"lived","word_index":4,"concept_id":null},
    {"id":5,"word":"in","word_index":5,"concept_id":null},
    {"id":6,"word":"Israel","word_index":6,"concept_id":null},
    {"id":7,"word":".","word_index":7,"concept_id":null},
    {"id":8,"word":"Elimelech's","word_index":8,"concept_id":null},
    {"id":9,"word":"wife's","word_index":9,"concept_id":null},
    {"id":10,"word":"name","word_index":10,"concept_id":null},
    {"id":11,"word":"was","word_index":11,"concept_id":null},
    {"id":12,"word":"Naomi","word_index":12,"concept_id":null},
    {"id":13,"word":".","word_index":13,"concept_id":null}
  ]

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
    '$scope'
    controller
  ]

