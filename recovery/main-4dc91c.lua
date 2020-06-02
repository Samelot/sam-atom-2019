local composer=require("composer")

utf8 = require( "plugin.utf8" )
ponyfont = require("ponyfont")

require("ssk2.loadSSK")
require("cf_game_settings")
require("cf_game_scale_components")
require("cf_game_sfx")
CFGameSettings = CFGameSettings()
CFGameScaleComponents = CFGameScaleComponents()
CFGameSFX = CFGameSFX()

display.setStatusBar( display.HiddenStatusBar )

_G.ssk.init({})
ssk.persist.setDefault( "score.json", "highScore", 0 )

_G.platform = system.getInfo( "platform" )
if platform == "android" then
	local function onResize( event )
		native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
	end
	Runtime:addEventListener( "resize", onResize )
end



function runMain()
	print("pixelHeight: " .. display.pixelHeight, "pixelWidth: " .. display.pixelWidth)

	_G.pixelRatio = display.pixelHeight / display.pixelWidth
	print("pixel ratio: " .. pixelRatio)

	-- Override Corona's core widget libraries with the files contained in this project's subdirectory.
	-- Argument "name" will be set to the name of the library being loaded by the require() function.
	local function onRequireWidgetLibrary(name)
		return require("_widget_library." .. name)
	end
	package.preload.widget = onRequireWidgetLibrary
	package.preload.widget_tableview = onRequireWidgetLibrary

	-- For xcode console output
	io.output():setvbuf( "no" )

	--composer.gotoScene( "unitTestListing" )

	-- SAM: delete?
	--_W = display.pixelWidth
	--_H = display.pixelHeight
	_G._W = display.contentWidth -- Get the width of the screen
	_G._H = display.contentHeight -- Get the height of the screen
	_G.fps = display.fps
	_G.scaleSuffix = display.imageSuffix
	-- print(scaleSuffix)

	-- print(display.safeActualContentWidth)

	print("width: " .. _W, "height: " .. _H)

	print("actualContentWidth: " .. display.actualContentWidth, "actualContentHeight: " .. display.actualContentHeight)

	defaultTransition="crossFade"

	overrideScore=true  --set true to test gameover.lua

	local showSplash = false    --set false to skip mageegames splash

	local fontFace
	local backgrounImage=nil
	local backgroundColor={255,255,255}

	_G.musicMenu = audio.loadStream( "magee_music/magee_main.mp3" ) -- rename magee_main.mp3 to magee_menu.mp3
	_G.musicGameOver = audio.loadStream( "magee_music/magee_gameover.mp3" )

	audio.reserveChannels( 2 )
	_G.audioReservedChannel1 = nil
	_G.audioReservedChannel2 = nil
	_G.audioReservedChannels = {nil, nil}
	_G.lastUsedChannel

	-- SAM: what is this?
	audioCanPlay=true

	local splash1 = display.newImageRect( "images/MMG1.png", 580, 320 )
	    splash1.anchorX=0.5
	    splash1.anchorY=0.5
	    splash1.x = _W/2
	    splash1.y = _H/2
	    splash1:toFront()

	local splash2 = display.newImageRect( "images/MMG2.png", 580, 320 )
	    splash2.anchorX=0.5
	    splash2.anchorY=0.5
	    splash2.x = _W/2
	    splash2.y = _H/2
	    splash2.alpha=0
	    splash2:toFront()

	local function eraseSplash()
	    display.remove(splash1)
	    display.remove(splash2)
	 composer.gotoScene( "menu", {effect = defaultTransition} )
	end

	local function fadeSplash()
	    check1=transition.to(splash2, {time=1500,alpha=1})
	    timer.performWithDelay(2500,eraseSplash,1)
	end

	--composer.recycleOnSceneChange = true

	-- SAM: cool, test this out. Do we still need it?
	function checkMemory(e)
	  collectgarbage();
	  print("Memory usage " .. collectgarbage("count"));
	  print("Texture memory usage " .. system.getInfo("textureMemoryUsed")/1024/1024 .. "MB")
	end

	-- SAM: what is this?
	function playSound(audioObj,chn)
		local chnUsed
		if audioCanPlay then
			chnUsed = audio.play(audioObj,{channel=chn})
	    end
	    return chnUsed
	end

	function makeTextButton(txt,x,y,opts)
		local options  = opts or {}

	    if environment=="simulator" then
	      fontFace = options.fontFace or "Helvetica"
	    elseif environment=="device" then
	      fontFace = options.fontFace or "federalescort3d"
	    end

	    local fontSize = options.fontSize or 24
	    local fontColor= options.fontColor or {255,255,255}
	    local param=options.param
	    local tapOrTouch=options.tapOrTouch or "tap"
	    local listener=options.listener
	    local group=options.group
	    local btn=display.newEmbossedText(txt,0,0,fontFace,fontSize)
	    btn:setFillColor(fontColor[1],fontColor[2],fontColor[3])
	    btn.x=x or _W/2
	    btn.y=y or _H/2
	    if param then
	    	btn.param=param
	    end
	    if listener then
	    	btn:addEventListener(tapOrTouch,listener)

	    end
	    if group then
	    	group:insert(btn)
	    end
	    return btn
	end

	if showSplash==true then
	    timer.performWithDelay(1000,fadeSplash,1)
	elseif showSplash==false then
	        display.remove(splash1)
	    display.remove(splash2)
	     composer.gotoScene( "menu", {effect = defaultTransition})
	end
end
runMain()
