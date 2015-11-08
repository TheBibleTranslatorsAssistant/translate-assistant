# A generalized module for creating mixins.
# From: http://hardrockcoffeescript.org/classes/extending_classes.html
factory = ->
  moduleKeywords = ['extended', 'included']
  class Module
    @extend: (obj) ->
      for key, value of obj when key not in moduleKeywords
        @[key] = value
      obj.extended?.apply(@)
      @

    @include: (obj) ->
      for key, value of obj when key not in moduleKeywords
        @::[key] = value
      obj.included?.apply(@)
      @

angular
  .module 'translateAssistant'
  .factory 'Module', [factory]

