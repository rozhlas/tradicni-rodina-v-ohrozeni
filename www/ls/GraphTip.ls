class ig.GraphTip
  (@graph) ->
    @element = @graph.parentElement.append \div
      ..attr \class "graph-tip"
    @content = @element.append \div
      ..attr \class \content
    @arrow = @element.append \div
      ..attr \class \arrow

  display: (x, y, content) ->
    @element.classed \active yes
    @content.html content
    width = @element.node!clientWidth
    height = @element.node!clientHeight
    xPosition = @graph.margin.left + x
    yPosition = @graph.margin.top + y
    left = xPosition - width / 2
    offset = 0
    if left < 0
      offset = left
      left = 0
    if left + width > @graph.fullWidth
      offset = left + width - @graph.fullWidth
      left = @graph.fullWidth - width
    top = yPosition - height
    @element
      ..style \left left + "px"
      ..style \top top + "px"
    @arrow.style \left offset + "px"

  hide: ->
    @element.classed \active no
