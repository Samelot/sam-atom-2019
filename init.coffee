# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-workspace', 'custom:cancel', (e) ->
  dismissedCounter = 0
  atom.notifications.getNotifications().forEach (notification) ->
    unless notification.dismissed
      notification.dismiss()
      dismissedCounter++
  if dismissedCounter is 0
    atom.commands.dispatch e.currentTarget, 'find-and-replace:toggle'

atom.commands.add '.find-and-replace', 'custom:where-from', (e) ->
    dock = atom.workspace.getBottomDock()
    console.log("working")
    # paneItem = dock.getActivePaneItem()
    # editor = @getModel()
    console.log(this)
    # console.log(e.currentTarget) # platform-darwin

    # center = atom.workspace.getCenter()
    # console.log(center)

    # console.log(dock.element)
    atom.commands.dispatch this, 'core:cancel'
    # if dock.state.visible is true
