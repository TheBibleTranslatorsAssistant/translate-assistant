controller = ($http, $scope) ->
  # Load words from the server
  $http({
    method: 'GET',
    url:    '/words'
  }).success (response) ->
    $scope.words = response
  
  $scope.definition = { id: null, searchText: null }
  $scope.propertyIsCompleted = ->
    return $scope.definition.id != null and $scope.definition.id != 'other'
  $scope.searchDefinitions = ->
    if $scope.definition.searchText != null
      loadDefinitionsForWord($scope.definition.searchText)
  $scope.showDefinitionPane = false
  
  $scope.startWordIndex = null
  $scope.startWith = (word, $event) ->
    $scope.startWordIndex = $scope.words.indexOf(word)
    $scope.endWordIndex = $scope.startWordIndex
    $scope.definition.id = null
    $event.stopPropagation()

  $scope.endWordIndex = null
  $scope.endWith = (word, $event) ->
    # Don't change end word if mouse isn't pressed
    return unless $event.which == 1
    $scope.endWordIndex = $scope.words.indexOf(word)
    $scope.showDefinitionPane = $scope.startWordIndex == $scope.endWordIndex
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
    $scope.selectionDidChange()

  $scope.definitionOptions = []
  $scope.selectionDidChange = ->
    min = Math.min($scope.startWordIndex, $scope.endWordIndex)
    max = Math.max($scope.startWordIndex, $scope.endWordIndex)

    # If the user selected a single word then refresh definition options
    if min == max
      selectedWord = $scope.words[min]
      loadDefinitionsForWord(selectedWord.word)
    else
      $scope.definitionOptions = []
  
  loadDefinitionsForWord = (text) ->
    console.log "fetching definitions for #{text}"
    $http({
      method: 'GET',
      url:    '/concepts'
      params: { q: text }
    }).success (response) ->
      $scope.definitionOptions = response

angular
  .module 'translateAssistant'
  .controller 'TranslateController', [
    '$http'
    '$scope'
    controller
  ]

