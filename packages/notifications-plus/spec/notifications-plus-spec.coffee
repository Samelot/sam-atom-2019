describe "Notifications Plus", ->

  describe "when the notifications package is enabled before activation", ->

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('notifications')

    it "disables the notifications package", ->
      expect(atom.packages.isPackageDisabled('notifications')).toBe false

      waitsForPromise ->
        atom.packages.activatePackage('notifications-plus')

      runs ->
        expect(atom.packages.isPackageDisabled('notifications')).toBe true

  describe "when the notifications package is enabled after activation", ->

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('notifications')

      runs ->
        atom.packages.disablePackage('notifications')

      waitsForPromise ->
        atom.packages.activatePackage('notifications-plus')

    it "disables the notifications package", ->
      atom.packages.enablePackage('notifications')

      expect(atom.packages.isPackageDisabled('notifications')).toBe true
