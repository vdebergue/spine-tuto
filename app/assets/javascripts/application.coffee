define ["controller","model"], (Tasks, Task) ->
  class TaskApp extends Spine.Controller
    @extend Spine.Log

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
      @log "new App"
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