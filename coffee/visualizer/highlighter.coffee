'use strict'

require '../helpers.coffee'
Tool = require './tool.coffee'
settings = require '../settings.coffee'
Intersection = require '../model/intersection.coffee'
DAT = require 'dat-gui'

class ToolHighlighter extends Tool
  constructor: ->
    super arguments...
    @hoveredCell = null
    @cellWindowGui = null

  mousemove: (e) =>
    cell = @getCell e
    hoveredIntersection = @getHoveredIntersection cell
    @hoveredCell = cell

    # Сбрасываем цвета во всех остальных ячейках 
    for id, intersection of @visualizer.world.intersections.all()
      intersection.color = null

    # А теперь делаем цвет ячейки
    if hoveredIntersection?
      hoveredIntersection.color = settings.colors.hoveredIntersection

  mouseout: =>
    @hoveredCell = null

  click: (e) =>
    cell = @getCell e
    hoverIntersection = @getHoveredIntersection cell
    
    console.log @cellWindowGui
    if @cellWindowGui
      @cellWindowGui.destroy()
      @cellWindowGui = null

    if hoverIntersection
      console.log 'click intersection'
      @cellWindowGui = new DAT.GUI()
      @cellWindowGui.add hoverIntersection, 'id'
      guiIntersectionCoord = @cellWindowGui.addFolder 'Координаты'
      guiIntersectionCoord.add hoverIntersection.rect, 'x'
      guiIntersectionCoord.add hoverIntersection.rect, 'y'
      guiIntersectionCoord.add hoverIntersection.rect, '_height'
      guiIntersectionCoord.add hoverIntersection.rect, '_width'
      guiIntersectionCoord.open()

      # ctx = @cellWindowGui
      # object =
      #   Close: () -> 
      #     ctx.destroy()
      #     ctx = null
      #     ctx

      # @cellWindowGui.add object, 'Close'
    
      console.log hoverIntersection

  draw: =>
    if @hoveredCell
      color = settings.colors.hoveredGrid
      @visualizer.graphics.fillRect @hoveredCell, color, 0.5

module.exports = ToolHighlighter
