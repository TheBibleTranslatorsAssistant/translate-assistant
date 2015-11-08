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

    @property 'groupType',
      get: -> @_groupType
      set: (groupType) ->
        @_groupType = groupType
        @save()

    save: =>
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
      $http(request)
        .success (data, status, headers, config) =>
          _.extend @, data

          # Fetch new WordGroups from server
          setTimeout WordGroup._fetchWordGroups, 0
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
      WordGroup._fetchWordGroups()

    @all: ->
      unless angular.isUndefined(WordGroup._allWordGroups)
        return WordGroup._allWordGroups

      # If we haven't fetched before:
      #  - set up an observer to track changes
      #  - fetch (and return a promise)
      WordGroup._allWordGroups = []
      return @_fetchWordGroups()

    @_fetchWordGroups: ->
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

