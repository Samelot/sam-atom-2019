SublimeWordNavigation = require '../lib/sublime-word-navigation'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'SublimeWordNavigation', ->
  editor = null
  editorElement = null

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()
    waitsForPromise ->
      atom.packages.activatePackage('sublime-word-navigation')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  # move-to-beginning-of-word
  describe 'sublime-word-navigation:move-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'moves to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 8)')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(1, 0)')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'moves to the beginning of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 15])
        editor.addCursorAtBufferPosition([1, 21])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(0, 8)', '(1, 10)'])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the beginning of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 1])
        editor.addCursorAtBufferPosition([2, 1])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(1, 0)', '(2, 0)'])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 0])
        editor.addCursorAtBufferPosition([2, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(0, 7)', '(1, 7)'])

  # move-to-end-of-word
  describe 'sublime-word-navigation:move-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'moves to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'moves to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'moves to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(1, 0)')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'moves to the end of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 0])
        editor.addCursorAtBufferPosition([1, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(0, 7)', '(1, 9)'])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at end of line, and end of word is on next line', ->
      it 'moves to the end of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 6])
        editor.addCursorAtBufferPosition([1, 6])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(0, 7)', '(1, 7)'])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is at end of line, and end of word is on next line', ->
      it 'moves to the beginning of the next line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 7])
        editor.addCursorAtBufferPosition([1, 7])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        actualPositions = editor.getCursorBufferPositions().map (position) ->
          position.toString()
        expect(actualPositions).toEqual(['(1, 0)', '(2, 0)'])

  # select-to-beginning-of-word
  describe 'sublime-word-navigation:select-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'selects to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('baz-qux')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('b')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('\n')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'selects to the beginning of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 15])
        editor.addCursorAtBufferPosition([1, 21])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(0, 8) - (0, 15)]',
          '[(1, 10) - (1, 21)]'
        ])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the beginning of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 1])
        editor.addCursorAtBufferPosition([2, 1])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(1, 0) - (1, 1)]',
          '[(2, 0) - (2, 1)]'
        ])

    describe 'when the event is triggered, there are multiple cursor, and each cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the end of the previous line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 0])
        editor.addCursorAtBufferPosition([2, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(0, 7) - (1, 0)]',
          '[(1, 7) - (2, 0)]'
        ])

  # select-to-end-of-word
  describe 'sublime-word-navigation:select-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'selects to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('foo-bar')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'selects to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('r')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'selects to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('\n')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'selects to the end of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.moveToBeginningOfLine()
        editor.setCursorBufferPosition([0, 0])
        editor.addCursorAtBufferPosition([1, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(0, 0) - (0, 7)]',
          '[(1, 0) - (1, 9)]'
        ])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at end of line, and end of word is on next line', ->
      it 'selects to the end of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 6])
        editor.addCursorAtBufferPosition([1, 6])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(0, 6) - (0, 7)]',
          '[(1, 6) - (1, 7)]'
        ])

    describe 'when the event is triggered, there are multiple cursors, and each cursor is at end of line, and end of word is on next line', ->
      it 'selects to the beginning of the next line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 7])
        editor.addCursorAtBufferPosition([1, 7])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('\n')
        actualRanges = editor.getSelectedBufferRanges().map (range) ->
          range.toString()
        expect(actualRanges).toEqual([
          '[(0, 7) - (1, 0)]',
          '[(1, 7) - (2, 0)]'
        ])

  # delete-to-beginning-of-word
  describe 'sublime-word-navigation:delete-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'deletes to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-')

    describe 'when the event is triggered and text is selected', ->
      it 'deletes the selected text', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()
        editor.selectLeft(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-baz')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar\naz-qux')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-qux')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'deletes to the beginning of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 15])
        editor.addCursorAtBufferPosition([1, 21])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-\nfizz-buzz-')

    describe 'when the event is triggered and text is selected and there are multiple cursors', ->
      it 'deletes the selected text, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 15])
        editor.addCursorAtBufferPosition([1, 21])
        editor.getSelections().forEach (selection) ->
          selection.selectLeft(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-baz\nfizz-buzz-bleep-b')

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the beginning of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 1])
        editor.addCursorAtBufferPosition([2, 1])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar\naz-qux\nizz-buzz')

    describe 'when the event is triggered, there are multiple cursors, and each cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the end of the previous line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([1, 0])
        editor.addCursorAtBufferPosition([2, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-quxfizz-buzz')

  # delete-to-end-of-word
  describe 'sublime-word-navigation:delete-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'deletes to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('-baz-qux')

    describe 'when the event is triggered and text is selected', ->
      it 'deletes the selected text', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()
        editor.selectRight(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('bar-baz-qux')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'deletes to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-ba\nbaz-qux')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'deletes to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-qux')

    describe 'when the event is triggered and there are multiple cursors', ->
      it 'deletes to the end of the next word, skipping any non-word characters, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 0])
        editor.addCursorAtBufferPosition([1, 0])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('-baz-qux\n-bleep-bloop')

    describe 'when the event is triggered and text is selected and there are multiple cursors', ->
      it 'deletes the selected text, for each cursor', ->
        editor.setText('foo-bar-baz-qux\nfizz-buzz-bleep-bloop')
        editor.setCursorBufferPosition([0, 0])
        editor.addCursorAtBufferPosition([1, 0])
        editor.getSelections().forEach (selection) ->
          selection.selectRight(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('bar-baz-qux\n-buzz-bleep-bloop')

    describe 'when the event is triggered, there are multiple cursors, and each cursor is not at end of line, and end of word is on next line', ->
      it 'deletes to the end of the current line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 6])
        editor.addCursorAtBufferPosition([1, 6])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-ba\nbaz-qu\nfizz-buzz')

    describe 'when the event is triggered, there are multiple cursors, and each cursor is at end of line, and end of word is on next line', ->
      it 'deletes to the beginning of the next line, for each cursor', ->
        editor.setText('foo-bar\nbaz-qux\nfizz-buzz')
        editor.setCursorBufferPosition([0, 7])
        editor.addCursorAtBufferPosition([1, 7])

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-quxfizz-buzz')
