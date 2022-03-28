Dot = {}
Dot.__index = Dot


function Dot:New(x,y,speed,cell)
    self = setmetatable({}, self)

    self.x  = x
    self.y  = y

    self.dx = math.random(2)*2 - 3
    self.dy = math.random(2)*2 - 3

    self.speed = speed
    self.delta = 0
    
    self.cell = cell
    
    return self
end


function Dot:Update(dt)

    self.delta = self.delta + self.speed*dt

    if self.delta >= 1 then

        local not_cell = F_NONE
        if self.cell == F_NONE then not_cell = F_FILL end

        if self.x + self.dx > MAX_X or self.x + self.dx < 1 then self.dx = -self.dx end
        if self.y + self.dy > MAX_Y or self.y + self.dy < 1 then self.dy = -self.dy end

        if self.cell == F_NONE and field[self.x+self.dx][self.y+self.dy] == F_TRACE then
            game:Over()
        end

        if self.x + self.dx < 1 or self.x + self.dx > MAX_X or
           field[self.x + self.dx][self.y] == not_cell then
            self.dx = - self.dx
        end

        if self.y + self.dy < 1 or self.y + self.dy > MAX_Y or
           field[self.x][self.y + self.dy] == not_cell then
            self.dy = - self.dy
        end

        if field[self.x + self.dx][self.y + self.dy] == not_cell then
            self.dx = - self.dx
            self.dy = - self.dy
        end

        self.x = self.x + self.dx
        self.y = self.y + self.dy

        self.delta = self.delta - 1

        if self.cell == F_FILL and player.x == self.x and player.y == self.y then
            game:Over()
        end
    end

end


function Dot:Draw()
    love.graphics.circle("line", OFFSET_X + (self.x-1)*CELL_SIZE_X+CELL_SIZE_X/2, 
                                 OFFSET_Y + (self.y-1)*CELL_SIZE_Y+CELL_SIZE_Y/2, 
                                 CELL_SIZE_X/3, 4)
end
