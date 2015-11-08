controller = ($http, $q, WordGroup, $scope) ->
  # Selection stuff
  $scope.startWordIndex = null
  $scope.startWith = (word, $event) ->
    $scope.startWordIndex = $scope.words.indexOf(word)
    $scope.endWordIndex = $scope.startWordIndex
    $scope.features.reset()
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
    $scope.selectedWordGroup = null
    $scope.selectionDidChange()
    $scope.features.reset()

  $scope.selectedWordGroup = null
  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()
    $scope.selectionDidChange()

  wordGroupMatchingIndexes = (startWordIndex, endWordIndex) ->
    min = Math.min(startWordIndex, endWordIndex)
    max = Math.max(startWordIndex, endWordIndex)
    startingId = $scope.words[min].id
    endingId   = $scope.words[max].id
    _.find $scope.wordGroups, (wg) ->
      wg.starting_word_id == startingId and wg.ending_word_id == endingId

  $scope.selectionDidChange = ->
    min = Math.min($scope.startWordIndex, $scope.endWordIndex)
    max = Math.max($scope.startWordIndex, $scope.endWordIndex)

    # Find or create matching wordGroup
    if $scope.startWordIndex != null and $scope.endWordIndex != null
      newWordGroup = new WordGroup({
        starting_word_id: $scope.words[min].id,
        ending_word_id:   $scope.words[max].id,
        definition_id:    if $scope.features.concept then $scope.features.concept.id else null
      })
      $scope.selectedWordGroup = wordGroupMatchingIndexes(min, max) || newWordGroup
    else
      $scope.selectedWordGroup = null

    # If the user selected a single word then refresh definition options
    updateIntersectingWordGroups()
    if min == max
      selectedWord = $scope.words[min]
      loadDefinitionsForWord(selectedWord.word)
      $scope.showDefinitionPane = true
      $scope.showGroupTypePane = false
    else
      $scope.definitionOptions = []
      $scope.showDefinitionPane = false
      $scope.showGroupTypePane = true

  updateIntersectingWordGroups = ->
    if $scope.startWordIndex == null or $scope.endWordIndex == null
      $scope.intersectingWordGroups = []
    else
      selectedMin = Math.min($scope.startWordIndex, $scope.endWordIndex)
      selectedMax = Math.max($scope.startWordIndex, $scope.endWordIndex)
      wordIds = _.map $scope.words, (word) -> word.id
      $scope.intersectingWordGroups = _.filter $scope.wordGroups, (wordGroup) ->
        wordGroupMin = wordIds.indexOf(wordGroup.starting_word_id)
        wordGroupMax = wordIds.indexOf(wordGroup.ending_word_id)
        minBetween = selectedMin >= wordGroupMin and selectedMin <= wordGroupMax
        maxBetween = selectedMax >= wordGroupMin and selectedMax <= wordGroupMax
        minBetween or maxBetween

  $scope.colorForWordGroup = (wordGroup) ->
    underlineColors[wordGroup.id%20]
  $scope.textForWordGroup = (wordGroup) ->
    wordIds    = _.map $scope.words, (word) -> word.id
    startIndex = wordIds.indexOf(wordGroup.starting_word_id)
    endIndex   = wordIds.indexOf(wordGroup.ending_word_id)
    words      = []
    for index in [startIndex..endIndex]
      words.push($scope.words[index].word)
    words.join(' ')

  $scope.highlightWordGroup = (wordGroup) ->
    wordIds = _.map $scope.words, (word) -> word.id
    $scope.startWordIndex = wordIds.indexOf(wordGroup.starting_word_id)
    $scope.endWordIndex = wordIds.indexOf(wordGroup.ending_word_id)
    $scope.selectionDidChange()

  # Load words from the server
  wordsPromise = $http({
    method: 'GET',
    url:    '/words'
  }).success (response) ->
    $scope.words = response
  
  # Load word groups from the server
  WordGroup.wordGroupsDidChange ->
    $scope.wordGroups = WordGroup.all()
    $scope.$digest() unless $scope.$$phase
    recalculateUnderlines()
  wordGroupsPromise = WordGroup.all()

  # Periodically update word groups
  setInterval WordGroup.fetch, 10*1000

  underlineColors = [
    '#1f77b4'
    '#aec7e8'
    '#ff7f0e'
    '#ffbb78'
    '#2ca02c'
    '#98df8a'
    '#d62728'
    '#ff9896'
    '#9467bd'
    '#c5b0d5'
    '#8c564b'
    '#c49c94'
    '#e377c2'
    '#f7b6d2'
    '#7f7f7f'
    '#c7c7c7'
    '#bcbd22'
    '#dbdb8d'
    '#17becf'
    '#9edae5'
  ]

  UNDERLINE_WEIGHT_IN_PIXELS = 3
  PADDING_BETWEEN_UNDERLINES_IN_PIXELS = 2
  $scope.boxShadowForWord = (word) ->
    return unless $scope.underlines and word.id of $scope.underlines
    underlines = $scope.underlines[word.id]
    parts = []
    yPosition = 0
    for underline in underlines
      yPosition += PADDING_BETWEEN_UNDERLINES_IN_PIXELS
      parts.push "0 #{yPosition}px 0 0 #ffffff"
      yPosition += UNDERLINE_WEIGHT_IN_PIXELS
      color = if underline then underlineColors[underline.id%20] else '#ffffff'
      parts.push "0 #{yPosition}px 0 0 #{color}"
    parts.join(',')
  recalculateUnderlines = ->
    return unless $scope.words and $scope.wordGroups
    wordIds = _.map $scope.words, (word) -> word.id
    $scope.underlines = {}
    for wordGroup in $scope.wordGroups
      startId    = wordGroup.starting_word_id
      startIndex = wordIds.indexOf(startId)
      endId      = wordGroup.ending_word_id
      endIndex   = wordIds.indexOf(endId)

      # Find the max index of items within (startIndex -> endIndex) so far
      maxCount = 0
      for index in [startIndex..endIndex]
        word = $scope.words[index]
        if word.id of $scope.underlines
          count = $scope.underlines[word.id].length
        else
          count = 0
        maxCount = count if count > maxCount

      # Add the word_group to items within (startIndex -> endIndex)
      for index in [startIndex..endIndex]
        word = $scope.words[index]
        $scope.underlines[word.id] ||= []
        while $scope.underlines[word.id].length < maxCount
          $scope.underlines[word.id].push(null)
        $scope.underlines[word.id].push(wordGroup)
  $q.all([wordsPromise, wordGroupsPromise]).then(recalculateUnderlines)

  $scope.hasSelection = -> $scope.startWordIndex != null and $scope.endWordIndex != null
  $scope.definitionOptions = []
  $scope.features = 
    concept:    null
    searchText: null
    plurality: null
    tense: null
    reset: ->
      @concept = null
      @plurality = null
      @tense = null
      @searchText = null
  $scope.definitionIsCompleted = ->
    $scope.features.concept != null and $scope.features.concept.id != 'other'
  $scope.hasNounConcept = ->
    $scope.definitionIsCompleted() and $scope.features.concept.concept_type == 'noun'
  $scope.hasVerbConcept = -> $scope.definitionIsCompleted() and $scope.features.concept.concept_type == 'verb'
  $scope.searchDefinitions = ->
    if $scope.features.searchText != null
      loadDefinitionsForWord($scope.features.searchText)
  $scope.shouldShowDefinitionSearchBox = ->
    $scope.features.concept != null and $scope.features.concept.id == 'other'
  throttleSearchDefinitions =
    jQuery.throttle(250, (text) ->
      if text != null and text != '' and text.length > 1
        $scope.searchDefinitions())
  $scope.$watch(
    "features.searchText",
    (newValue, oldValue) -> throttleSearchDefinitions(newValue))
  
  $scope.pluralities = [
    { id: 1, title: "Singular" },
    { id: 2, title: "Plural" }
  ]
  
  $scope.tenses = [
    { id: 1, title: "Past" },
    { id: 2, title: "Present" },
    { id: 3, title: "Future" }
  ]
  
  loadDefinitionsForWord = (text) ->
    $http({
      method: 'GET',
      url:    '/concepts'
      params: { q: text }
    }).success (response) ->
      $scope.definitionOptions = response

  # Group type
  $scope.showGroupType = false
  $scope.groupTypeIsCompleted = ->
    !!$scope.selectedWordGroup.groupType
  $scope.groupTypeOptions = [
    "Sentence"
    "Noun phrase"
    "Verb phrase"
    "Not sure"
  ]

  $scope.deleteSelectedWordGroup = ->
    $scope.selectedWordGroup.delete()
    $scope.clearHighlight()

angular
  .module 'translateAssistant'
  .controller 'TranslateController', [
    '$http'
    '$q'
    'WordGroup'
    '$scope'
    controller
  ]

