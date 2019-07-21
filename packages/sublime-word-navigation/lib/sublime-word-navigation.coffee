{CompositeDisposable} = require 'atom'

module.exports = SublimeWordNavigation =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'sublime-word-navigation:move-to-beginning-of-word': => @moveToBeginningOfWord()
      'sublime-word-navigation:move-to-end-of-word': => @moveToEndOfWord()
      'sublime-word-navigation:select-to-beginning-of-word': => @selectToBeginningOfWord()
      'sublime-word-navigation:select-to-end-of-word': => @selectToEndOfWord()
      'sublime-word-navigation:delete-to-beginning-of-word': => @deleteToBeginningOfWord()
      'sublime-word-navigation:delete-to-end-of-word': => @deleteToEndOfWord()

  deactivate: ->
    @subscriptions.dispose()

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getCursors: ->
    @getEditor().getCursors()

  getSelections: ->
    @getEditor().getSelections()

  moveCursorToBeginningOfWord: (cursor) ->
    beginningOfWordPosition = cursor.getBeginningOfCurrentWordBufferPosition({
      includeNonWordCharacters: false
    })
    if cursor.isAtBeginningOfLine()
      cursor.moveUp()
      cursor.moveToEndOfLine()
    else if beginningOfWordPosition.row < cursor.getBufferPosition().row
      cursor.moveToBeginningOfLine()
    else
      cursor.setBufferPosition(beginningOfWordPosition)

  moveCursorToEndOfWord: (cursor) ->
    endOfWordPosition = cursor.getEndOfCurrentWordBufferPosition({
      includeNonWordCharacters: false
    })
    if cursor.isAtEndOfLine()
      cursor.moveDown()
      cursor.moveToBeginningOfLine()
    else if endOfWordPosition.row > cursor.getBufferPosition().row
      cursor.moveToEndOfLine()
    else
      cursor.setBufferPosition(endOfWordPosition)

  moveToBeginningOfWord: ->
    @getCursors().forEach(@moveCursorToBeginningOfWord)

  moveToEndOfWord: ->
    @getCursors().forEach(@moveCursorToEndOfWord)

  selectToBeginningOfWord: ->
    @getSelections().forEach (selection) =>
      selection.modifySelection => @moveCursorToBeginningOfWord(selection.cursor)

  selectToEndOfWord: ->
    @getSelections().forEach (selection) =>
      selection.modifySelection => @moveCursorToEndOfWord(selection.cursor)

  deleteToBeginningOfWord: ->
    @getEditor().mutateSelectedText (selection) =>
      if selection.isEmpty()
        selection.modifySelection => @moveCursorToBeginningOfWord(selection.cursor)
      selection.deleteSelectedText()

  deleteToEndOfWord: ->
    @getEditor().mutateSelectedText (selection) =>
      if selection.isEmpty()
        selection.modifySelection => @moveCursorToEndOfWord(selection.cursor)
      selection.deleteSelectedText()
