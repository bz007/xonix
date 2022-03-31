--
-- Класс для модальных диалогов
-- 

Dialog = {}
Dialog.__index = Dialog

function Dialog:New(msg1, msg2)

	self.msg1 = msg1
	self.msg2 = msg2

	self.state = 0

	self.context_save = context
	context = self

	return self
end


function Dialog:Draw()

    local c1 = {1,.3,.3}; c2 = {0,1,0}; color = {c1, c2}

    n = math.floor(self.state * 2) % 2
    msg = {color[1+n], self.msg1, color[2-n], self.msg2}

    self.context_save:Draw()

    love.graphics.setColor(.7, .7, .7)
    love.graphics.rectangle('fill', screen.width/8, screen.height/4, screen.width*3/4, screen.height/2)

    love.graphics.setFont(fontM)
    love.graphics.printf(msg, 0, screen.height*2/5, screen.width, 'center')

    love.graphics.setFont(font)
    love.graphics.printf({{0,0,1}, 'press Enter'}, screen.width/4, screen.height*5/8, screen.width/2, 'center')

end


function Dialog:Update(dt)
	self.state = self.state + dt

    if self.state > 1 then
    	self.state = self.state - 1
    end
end


function Dialog:Event(key)

	if key == 'return' then
		context = self.context_save
	elseif key == 'escape' then
		context = self.context_save
	elseif key == 'q' then
		love.event.quit()
	end

end
