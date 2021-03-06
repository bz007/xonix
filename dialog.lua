--
-- Класс для модальных диалогов
-- 

Dialog = {}
Dialog.__index = Dialog

function Dialog:New(msg1, msg2)

    self.msg1 = msg1
    self.msg2 = msg2

    self.state = 0

    self.context_save = context.current()

    context.push(self)

    return self
end


function Dialog:draw()

    local c1 = {1,.3,.3}
    local c2 = {0,1,0}
    local color = {c1, c2}

    n = math.floor(self.state * 2) % 2
    msg = {color[1+n], self.msg1, color[2-n], self.msg2}

    self.context_save:draw()

    love.graphics.setColor(.7, .7, .7)
    love.graphics.rectangle('fill', screen.width/8, screen.height/4, screen.width*3/4, screen.height/2)

    love.graphics.setFont(fontM)
    love.graphics.printf(msg, 0, screen.height*2/5, screen.width, 'center')

    love.graphics.setFont(font)
    love.graphics.printf({{0,0,1}, 'press FIRE'}, screen.width/4, screen.height*5/8, screen.width/2, 'center')

end


function Dialog:update(dt)
    self.state = self.state + dt

    if self.state > 1 then
        self.state = self.state - 1
    end
end


function Dialog:keypressed(key)

    if key == 'return' or key == 'escape' then
        -- context = self.context_save
        return context.pop()
    elseif key == 'q' then
        love.event.quit()
    end

end


function Dialog:gamepadpressed(joystick, button)
    if button == 'a' then
        -- context = self.context_save
        return context.pop()
    end
end
