factory = ->
  observable =
    _observers: {}

    publish: (key) ->
      if key of @_observers
        for fn in @_observers[key]
          fn()

    subscribe: (key, fn) ->
      @_observers[key] ||= []
      @_observers[key].push(fn)

angular
  .module 'translateAssistant'
  .factory 'Observable', [factory]

