-- игрок

Player = {}
Player.__index = Player

function Player:New(speed)
    self = setmetatable({}, self)

    self:Init()
    self.speed = speed
    self.delta = 0

    return self
end


function Player:Init()
    self.x = math.floor(MAX_X/2)
    self.y = 1
    self.dir = DIR_NO
end


function Player:keypressed(key)
    if key == 'down' then
        self.dir = DIR_DN
    elseif key == 'up' then
        self.dir = DIR_UP
    elseif key == 'left' then
        self.dir = DIR_LT
    elseif key == 'right' then
        self.dir = DIR_RT
    end
end


function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", OFFSET_X + player.x*CELL_SIZE_X - CELL_SIZE_X/2, 
                                 OFFSET_Y + player.y*CELL_SIZE_Y - CELL_SIZE_Y/2, CELL_SIZE_X/2)
    love.graphics.setColor(.5, 1, .5)
    love.graphics.circle("fill", OFFSET_X + player.x*CELL_SIZE_X - CELL_SIZE_X/2, 
                                 OFFSET_Y + player.y*CELL_SIZE_Y - CELL_SIZE_Y/2, CELL_SIZE_X/4)
    love.graphics.setFont(fontS)
    love.graphics.printf({{.5,1,.5,.5},
        'Level: '..level..' Lives: '..lives..' Score: '..score..' Filled: '..filledp..'%'}, 
        0, screen.height-fontS:getHeight(), screen.width, 'center')
end


function Player:update(dt)
    if self.dir == DIR_NO then return end

    self.delta = self.delta + self.speed*dt

    if self.delta >= 1 then

        field_prev = field[self.x][self.y]

        if field[self.x][self.y] == F_NONE then
            field[self.x][self.y] = F_TRACE
        end


        if self.dir == DIR_DN and self.y < MAX_Y then
            self.y = self.y + 1
        elseif self.dir == DIR_UP and self.y > 1 then
            self.y = self.y - 1
        elseif self.dir == DIR_RT and self.x < MAX_X then
            self.x = self.x + 1
        elseif self.dir == DIR_LT and self.x > 1 then
            self.x = self.x - 1
        end
        self.delta = self.delta - 1

        if field[self.x][self.y] == F_TRACE then
            game:Over()
        elseif field[self.x][self.y] == F_FILL and field_prev == F_NONE then
            -- завершили линию, остановка
            self.dx, self.dy, self.delta = 0, 0, 0
            self.dir = DIR_NO

            -- заливка и подсчёт очков
            for _, dot in pairs(outdots) do
                fill(dot.x, dot.y, F_NONE, F_REST)
            end
            for i = 1, MAX_X do
                for j = 1, MAX_Y do
                    if field[i][j] == F_REST then
                        field[i][j] = F_NONE
                    elseif field[i][j] == F_NONE or field[i][j] == F_TRACE then
                        field[i][j] = F_FILL
                        score = score + 1
                        filled = filled + 1
                    end
                end
            end
            -- percent filled
            filledp = math.floor( .5 + filled * 100 / ((MAX_X - 4) * (MAX_Y - 4)) )
            if filledp >= 75 then
                
                sound_levelup:play()
                Dialog:New('LEVEL', ' UP!!!')

                level = level + 1
                lives = lives + 1

                game:make_field(level)
            end
        end
    end

end


-- функция заливки, начинает с координат x,y и заменяет в области цвет bg на fil
function fill(x, y, bg, fil)
    if field[x][y] ~= bg then return end

    field[x][y] = fil

    if x < MAX_X then fill(x+1, y, bg, fil) end
    if x > 1     then fill(x-1, y, bg, fil) end
    if y < MAX_Y then fill(x, y+1, bg, fil) end
    if y > 1     then fill(x, y-1, bg, fil) end

end
