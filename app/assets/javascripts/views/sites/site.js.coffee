class Kuiper.SiteView extends Batman.View
  @option "site"

  ready: ->
    site = @get('site')
    
    if site.get('online_visitor_counts.length') > 0
      html = @get('node')
      chart_el = $(html).find(".online_visitors_graph")
      chart = new Rickshaw.Graph
        element: html.querySelector(".online_visitors_graph")
        width: chart_el.width()
        height: chart_el.height()
        renderer: "area"
        interpolation: "basis"
        series: [{
          name: "People online"
          data: @mapVisitorCounts site.get('online_visitor_counts')
        }]

      tooltip = new Rickshaw.Graph.HoverDetail
        graph: chart
        formatter: (series, x, y) ->
          "<span class='name'>#{series.name}: #{y}</span>" + 
          "<span class='date'>#{new Date(x * 1000).toUTCString()}</span>"

      chart.render()

      site.observe "online_visitor_counts", (newValue, oldValue) =>
        chart.series[0].data = @mapVisitorCounts(newValue)
        chart.render()

  mapVisitorCounts: (visitor_counts) ->
    counts = _.map visitor_counts, (ovc) ->
      { x: ovc.created_at, y: ovc.count }
    counts = _.sortBy counts, (count) ->
      count.x
    console?.log counts
    counts
