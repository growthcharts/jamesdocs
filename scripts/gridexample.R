testplot <- function() {
  paper <- plotViewport(c(5, 4, 2, 2), name = "paper")
  plotregion <- dataViewport(pressure$temperature, pressure$pressure, name = "plotregion")
  rect <- rectGrob(vp = "plotregion", gp = gpar(fill = "lightgreen"), name = "plotrect")
  points <- pointsGrob(pressure$temperature, pressure$pressure, name = "dataSymbols", vp = "plotregion")
  xaxis <- xaxisGrob(vp = "plotregion", name = "xaxis")
  yaxis <- yaxisGrob(vp = "plotregion", name = "yaxis")
  gTree(children = gList(rect, points, xaxis, yaxis),
        vp = paper, childrenvp = plotregion, name = "example")
}
