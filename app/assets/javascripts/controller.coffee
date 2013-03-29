define ->
  class Tasks extends Spine.Controller
    events:
     "change   input[type=checkbox]": "toggle"
     "click    .destroy":             "destroyItem"

    constructor: ->
      super
      @item.bind("update",  @render)
      @item.bind("destroy", @remove)

    render: =>
      @html Mustache.render($("#taskTemplate").html(), @item)
      @

    remove: =>
      @el.remove()

    toggle: ->
      @item.done = !@item.done
      @item.save()

    destroyItem: ->
      @item.destroy()

  return Tasks