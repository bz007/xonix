-- 
-- Home screen
-- главный экран игры
-- 

Home = {}
Home.__index = Home

function Home:New()

    sound_startup = love.audio.newSource('res/Startup.ogg', 'static')
    sound_startup:play()

	return self
end

function Home:Draw()

    love.graphics.setColor(.2, .2, .2)
    love.graphics.rectangle('fill', 0, 0, screen.width, screen.height)

    love.graphics.setFont(fontH)
    love.graphics.setColor(.3, .9, .2)
    love.graphics.printf("XONIX", 0, 0, screen.width, 'center')
    love.graphics.setFont(fontS)
    love.graphics.setColor(.3, .9, .2, .3)
    -- подсказка по клавишам
    love.graphics.printf('[FIRE] start [M]usic on/off [F]ull screen [Q]uit © bz, 2022',
        0, screen.height-fontS:getHeight(), screen.width, 'center')

    love.graphics.setFont(font)
    love.graphics.setColor(1,1,1)
    love.graphics.printf('Hi score table:', screen.width/4, screen.height*4/11, screen.width/2, 'left')
    -- таблица рекордов
    for i = 1, #config.hiscore do
    	if hiscore_ptr == i then
    		love.graphics.setColor(1,.1,.1)
    	else
    		love.graphics.setColor(.9,.9,1)
    	end
    	love.graphics.printf(i..') '..config.hiscore[i][1].." "..config.hiscore[i][3],
    		screen.width/8, screen.height*(4+i)/11, screen.width*3/4, 'left')
    end

end

function Home:Update(dt)

end

function Home:Event(key)
	if key == 'return' then

		Game:Start('kbd')

	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())
		local fullscreen = love.window.getFullscreen()
		if fullscreen == false then
			love.window.setMode(800, 600, {resizable=false})
		end
		love.resize(love.graphics.getDimensions())
		config.fullscreen = fullscreen
		saveconfig()

	elseif key == 'm' then
		if background_music:isPlaying() then
			love.audio.stop(background_music)
			config.music = false
		else
			love.audio.play(background_music)
			config.music = true
		end
		saveconfig()

	elseif key == 'kp+' or key == '=' then
		local volume = background_music:getVolume()
		volume = volume / .8
		if volume > 1 then volume = 1 end
		background_music:setVolume(volume)
		config.volume = volume
		saveconfig()

	elseif key == 'kp-' or key == '-' then
		local volume = background_music:getVolume()
		volume = volume * .8
		background_music:setVolume(volume)
		config.volume = volume
		saveconfig()

	elseif key == 'q' then
		love.event.quit()
	end
end


active_joystick = {}
function Home:gamepadpressed(joystick, button)

	if button == 'a' then
		active_joystick = joystick
		Game:Start('js')
	end

end
