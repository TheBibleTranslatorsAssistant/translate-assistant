Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

factory = ($q, $http) ->
  class WordGroup
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
        .success (data, status, headers, config) => _.extend @, data
        .error (data, status, headers, config) ->
          console.log "Oh no, there was an error saving the word group."

angular
  .module 'translateAssistant'
  .factory 'WordGroup', ['$q', '$http', factory]

