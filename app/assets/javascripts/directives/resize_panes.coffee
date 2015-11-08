directive = ($window) ->
  hash =
    link: (scope, element, attrs) ->
      NAVBAR_HEIGHT = $('.navbar').outerHeight()
      resize = _.throttle ->
        windowHeight = $(window).height()
        targetHeight = windowHeight - NAVBAR_HEIGHT
        $('.source-text').height(targetHeight)
        $('.pane-container').height(targetHeight)
      , 100
      resize()

      # Bind the handler
      angular.element($window).bind 'resize', resize

      # Unbind the handler when the element is destroyed
      element.on '$destroy', ->
        angular.element($window).unbind 'resize', resize

angular
  .module('translateAssistant')
  .directive 'trResizePanes', ['$window', directive]

