Points = new Meteor.Collection "points"
Frigates = new Meteor.Collection "frigates"

if Meteor.isClient
  Template.board.points = ->
    Points.find().fetch()
  Template.point.events
    "click .square": ->
      if Points.findOne(this._id).covered
        Points.update this._id, $set: {covered: ""}
      else
        Points.update this._id, $set: {covered: "ship-part"}
  Template.harbor.frigates = ->
    Frigates.find().fetch()

  Template.frigate.events
    "click .ship-part": ->
      console.log "ship-part click"

  Template.board.rendered = ->
    $("#board").droppable
      drop: ->
        console.log "dropped"
  Template.harbor.rendered = ->
    $("#harbor").droppable
      drop: ->
        console.log "dropped in harbor"
  Template.frigate.rendered = ->
    $(".ship").draggable
      appendTo: $("#harbor")
      revert: "invalid"
      snap: ".square"


if Meteor.isServer
  Meteor.startup ->
    return Meteor.methods
      resetBoard: ->
        Points.remove {}
        if Points.find().count() is 0
          for i in [1..10]
            for j in [1..10]
              Points.insert {x: i, y: j, covered: ""}
      resetFrigates: ->
        Frigates.remove {}
        if Frigates.find().count() is 0
          for i in [1..1]
            Frigates.insert
              parts:[
                {head: false, cords: {x: 0, y: 0}},
                {head: false, cords: {x: 0, y: 0}},
                {head: true, cords: {x: 0, y: 0}},
                src: "http://www.globaltimes.cn/Portals/0/attachment/2011/53a972c6-f887-4fcc-94c9-9337e7aec919.jpg"
              ]
