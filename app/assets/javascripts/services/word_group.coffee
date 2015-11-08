Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

factory = ($q, $http, Module, Observable) ->
  class WordGroup extends Module
    @include Observable

    constructor: (hash) ->
      if hash
        @id               = hash.id
        @starting_word_id = hash.starting_word_id
        @ending_word_id   = hash.ending_word_id
        @_groupType       = hash.group_type
        @_conceptId       = hash.concept_id
        @_plurality       = hash.plurality
        @_tense           = hash.tense

    @property 'groupType',
      get: -> @_groupType
      set: (groupType) ->
        @_groupType = groupType
        @save()
        
    @property 'plurality',
      get: -> @_plurality
      set: (plurality) ->
        @_plurality = plurality
        @save()
        
    @property 'tense',
      get: -> @_tense
      set: (tense) ->
        @_tense = tense
        @save()

    @property 'conceptId',
      get: -> @_conceptId
      set: (conceptId) ->
        @_conceptId = conceptId
        @save()

    save: =>
      return if @_autoSaveDisabled
      if @id
        request =
          method: 'PUT'
          url: "/word-groups/#{@id}"
      else
        request =
          method: 'POST'
          url: "/word-groups"
      request.data =
        word_group:
          starting_word_id: @starting_word_id
          ending_word_id:   @ending_word_id
          group_type:       @groupType
          concept_id:       @conceptId
          plurality:        @plurality
          tense:            @tense
      $http(request)
        .success (data, status, headers, config) =>
          @_autoSaveDisabled = true
          _.extend @, data
          @_autoSaveDisabled = false
          
          # Fetch new WordGroups from server
          setTimeout WordGroup.fetch, 0
        .error (data, status, headers, config) ->
          console.log "Oh no, there was an error saving the word group."

    delete: =>
      if @id
        request =
          method: 'DELETE'
          url: "/word-groups/#{@id}"
        $http(request)
          .error (data, status, headers, config) ->
            console.log "Oh no, there was an error deleting the word group."
      WordGroup.fetch()

    @all: ->
      unless angular.isUndefined(WordGroup._allWordGroups)
        return WordGroup._allWordGroups

      # If we haven't fetched before:
      #  - set up an observer to track changes
      #  - fetch (and return a promise)
      WordGroup._allWordGroups = []
      return @fetch()

    @fetch: ->
      promise = $http({
        method: 'GET',
        url:    '/word-groups'
      }).success (response) =>
        WordGroup._allWordGroups = _.map response, (wordGroupHash) ->
          new WordGroup(wordGroupHash)
        if WordGroup._wordGroupChangeObservers
          for observer in WordGroup._wordGroupChangeObservers
            observer()

    @wordGroupsDidChange: (fn) ->
      WordGroup._wordGroupChangeObservers ||= []
      WordGroup._wordGroupChangeObservers.push(fn)

angular
  .module 'translateAssistant'
  .factory 'WordGroup', ['$q', '$http', 'Module', 'Observable', factory]

