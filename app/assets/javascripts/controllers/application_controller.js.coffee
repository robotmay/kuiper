class Kuiper.ApplicationController extends Batman.Controller
  layout: "application"

  constructor: ->
    super

    # Probably not ideal
    @set 'sites', Kuiper.Site.get('all')

  render: (options = {}) ->
    layout = options.layout ? @layout ? Batman.helpers.underscore(@get('routingKey'))

    if layout
      # Prefetch the action's view in parallel
      source = options.source || Batman.helpers.underscore(@get('routingKey') + '/' + @get('action'))
      Batman.View.store.prefetch source

      # Fetch the layout's view and apply context
      layoutView = @renderCache.viewForOptions
        viewClass: Batman.View
        context: @get('_renderContext')
        source: Batman.helpers.underscore('layouts/' + layout)

      # Render the layout's view into the DOM, the action into the layout
      layoutView.on 'ready', =>
        Batman.DOM.Yield.withName(options.into || @defaultRenderYield).replace layoutView.get('node')
        options.into = 'content' # TODO: Make customizable somehow
        super(options)

    else
      super(options)
