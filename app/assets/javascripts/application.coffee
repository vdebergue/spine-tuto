class Task extends Spine.Model
  @configure "Task", "name", "done"

  # localstorage:
  @extend Spine.Model.Local

  @active: ->
    @select (item) -> !item.done

  @done: ->
    @select (item) -> !!item.done

  @destroyDone: ->
    rec.destroy() for rec in @done()

window.Task = Task

class TaskApp extends Spine.Controller
  # Add event listeners
  events:
    "submit form":   "create"
    "click  .clear": "clear"

  elements:
    ".items":     "items"
    "form input": "input"
    "#countVal" : "numero"

  constructor: ->
    super
    Task.bind("create",  @addOne)
    Task.bind("refresh", @addAll)
    Task.bind("refresh change", @renderFooter)
    Task.fetch()

  addOne: (task) =>
    view = new Tasks(item: task)
    @items.append(view.render().el)

  addAll: =>
    Task.each(@addOne)

  create: (e) ->
    e.preventDefault()
    Task.create(name: @input.val())
    @input.val("")

  clear: ->
    Task.destroyDone()

  renderFooter: =>
    num = Task.active().length
    @numero.html(num + "")


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

jQuery ($) ->
  new TaskApp(el: $("#tasks"))