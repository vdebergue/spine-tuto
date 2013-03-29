define ->
  class Task extends Spine.Model
    @configure "Task", "name", "done"

    # localstorage:
    @extend Spine.Model.Ajax
    @url: "/tasks"

    @active: ->
      @select (item) -> !item.done

    @done: ->
      @select (item) -> !!item.done

    @destroyDone: ->
      rec.destroy() for rec in @done()

  return Task