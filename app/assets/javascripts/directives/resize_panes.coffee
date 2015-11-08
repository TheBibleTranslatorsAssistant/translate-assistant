directive = ($window) ->
  hash =
    link: (scope, element, attrs) ->
      NAVBAR_HEIGHT = $('.navbar').outerHeight()
      MARGIN_ABOVE  = 8
      MARGIN_BELOW  = 8
      resize = _.throttle ->
        windowHeight = $(window).height()

        # Source text
        PANEL_HEADER_HEIGHT = 94
        targetHeight = windowHeight - NAVBAR_HEIGHT - MARGIN_ABOVE - PANEL_HEADER_HEIGHT - MARGIN_BELOW
        $('.source-text .panel-body').height(targetHeight)

        # Pane container
        targetHeight = windowHeight - NAVBAR_HEIGHT - MARGIN_ABOVE - MARGIN_BELOW
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

