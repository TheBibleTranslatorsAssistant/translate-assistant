factory = ($q, $http, Observable) ->
  class TestClass
    constructor: (name) ->
      @name = name

angular
  .module 'translateAssistant'
  .factory 'TestClass', ['$q', '$http', 'Observable', factory]

