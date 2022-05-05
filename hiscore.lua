--
-- Диалог для ввода нового имени рекордсмена
-- 

HiScore = {}
HiScore.__index = HiScore

function HiScore:New()

    self.state = 0

    self.context_save = context.current()

    context.push(self)

    return self
end


function HiScore:draw()

    local c1 = {1,.3,.3}
    local c2 = {0,1,0}
    local cursor = {' ', '_'}
    local n = 1 + (math.floor(self.state * 2) % 2)

    self.context_save:draw()

    love.graphics.setColor(.7, .7, .7)
    love.graphics.rectangle('fill', screen.width/8, screen.height/4, screen.width*3/4, screen.height/2)

    love.graphics.setColor(c1)
    love.graphics.setFont(fontM)
    love.graphics.printf('Hi score!', 0, screen.height/4, screen.width, 'center')

    love.graphics.setFont(font)
    love.graphics.printf({{0,0,1},'Enter your name:'}, screen.width/8, screen.height/2-font:getHeight(), screen.width*3/4, 'center')

    love.graphics.setFont(fontM)
    love.graphics.setColor(c2)
    love.graphics.printf(config.name..cursor[n], screen.width/6, screen.height/2, screen.width*3/4)

end


function HiScore:update(dt)
    self.state = self.state + dt

    if self.state > 1 then
        self.state = self.state - 1
    end
end


function HiScore:keypressed(key)

    -- print(key)
    if key == 'return' or key == 'escape' then
        -- выход только если имя не пустое
        if #config.name > 0 then
            return context.pop()
        end
    elseif key == 'backspace' then
        if #config.name > 0 then
            config.name = string.sub(config.name,1,-2)
        end
    elseif string.find('abcdefghijklmnopqrstuvwxyz0123456789-.,', key, 1, true) then
        if #config.name < 10 then
            config.name = config.name .. key
        end
    end

end


function HiScore:gamepadpressed(joystick, button)
    if button == 'a' then
        -- context = self.context_save
        return context.pop()
    end
end

function HiScore:leave()
    if hiscore_ptr > 0 then
        table.insert(config.hiscore, hiscore_ptr, {score, level, config.name, os.date("%d.%m.%Y")})
        table.remove(config.hiscore)
        saveconfig()
    end
end
