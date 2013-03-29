require ["application"], (TaskApp) ->
  jQuery ($) ->
    new TaskApp(el: $("#tasks"))