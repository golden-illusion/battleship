Points = new Meteor.Collection "points"

if Meteor.isClient
  Template.board.points = ->
    Points.find().fetch()

  Template.point.end_row = ->
    this.y is 10

  Template.point.events
    "click .square": ->
      if Points.findOne(this._id).ship_part
        Points.update this._id, ship_part: ""
      else
        Points.update this._id, ship_part: "ship-part"

if Meteor.isServer
  Meteor.startup ->
    return Meteor.methods
      removeAll: ->
        return Points.remove {}
      createAll: ->
        if Points.find().count() is 0
          for i in [1..10]
            for j in [1..10]
              Points.insert {x: i, y: j, ship_part: ""}
