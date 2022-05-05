--
-- Непостедственно игровой процесс
-- 

Game = {}
Game.__index = Game


-- инициализация игры
function Game:New()

    hiscore_ptr = 0
    score = 0

    sound_gameover = love.audio.newSource('res/GameOver.ogg', 'static')
    sound_levelup  = love.audio.newSource('res/LevelUp.ogg',  'static')
    sound_hiscore  = love.audio.newSource('res/HiScore.ogg',  'static')

	return self

end



function Game:draw()
    -- фон
    love.graphics.setColor(.1, .1, .1)
    love.graphics.rectangle("fill", OFFSET_X, OFFSET_Y, MAX_X*CELL_SIZE_X, MAX_Y*CELL_SIZE_Y)

    -- клетки поля
    love.graphics.setColor(.1, .3, .1)
    for i = 1, MAX_X do
        for j = 1, MAX_Y do
            if field[i][j] == F_FILL then
                -- заполненные
                love.graphics.rectangle("fill", OFFSET_X + (i-1)*CELL_SIZE_X, 
                                                OFFSET_Y + (j-1)*CELL_SIZE_Y, 
                                                CELL_SIZE_X-1, CELL_SIZE_Y-1)
            elseif field[i][j] == F_TRACE then
                -- след игрока
                love.graphics.rectangle("line", OFFSET_X + (i-1)*CELL_SIZE_X + CELL_SIZE_X/4, 
                                                OFFSET_Y + (j-1)*CELL_SIZE_Y + CELL_SIZE_Y/4, 
                                                CELL_SIZE_X/2, CELL_SIZE_Y/2)

            end
        end
    end

    -- точки
    love.graphics.setColor(0.9, 0.7, 0)
    for _, dot in pairs(indots) do
        dot:draw()
    end

    love.graphics.setColor(0.9, 0.1, 0.5)
    for _, dot in pairs(outdots) do
        dot:draw()
    end

    -- игрок
    player:draw()

end


function Game:update(dt)

    player:update(dt)

    for _, dot in pairs(indots) do
           dot:update(dt)
    end

    for _, dot in pairs(outdots) do
           dot:update(dt)
    end

end


local active_joystick = nil

function Game:enter(prev_state, control, joystick)

    self.control = control
    active_joystick = joystick

    level = 1
    score = 0
    lives = 3

    game:make_field(level)

end


function Game:keypressed(key)

    if self.control ~= 'kbd' then
        return
    end

    if key == 'escape' then
        Dialog:New('Pause', ' Wait!')
    elseif key == 'q' then
        lives = 0
        Game:Over()
    end

    player:keypressed(key)

end


function Game:gamepadpressed(joystick, button)
    if self.control == 'js' and active_joystick == joystick then
        if button == 'a' then
            Dialog:New('Pause', ' Wait!')
        end
    end
end


local joystick_limit = .8 -- чувствительность
local ax = {leftx=0, lefty=0, rightx=0, righty=0}

function Game:gamepadaxis(joystick, axis, value)

    if self.control == 'js' and active_joystick == joystick then
        ax[axis] = value

        -- левый джойстик
        if math.abs(ax.leftx) < joystick_limit then
            if ax.lefty > joystick_limit then
                player.dir = DIR_DN
            elseif ax.lefty < -joystick_limit then
                player.dir = DIR_UP
            end
        end
        if math.abs(ax.lefty) < joystick_limit then
            if ax.leftx > joystick_limit then
                player.dir = DIR_RT
            elseif ax.leftx < -joystick_limit then
                player.dir = DIR_LT
            end
        end

        -- правый джойстик
        if math.abs(ax.rightx) < joystick_limit then
            if ax.righty > joystick_limit then
                player.dir = DIR_DN
            elseif ax.righty < -joystick_limit then
                player.dir = DIR_UP
            end
        end
        if math.abs(ax.righty) < joystick_limit then
            if ax.rightx > joystick_limit then
                player.dir = DIR_RT
            elseif ax.rightx < -joystick_limit then
                player.dir = DIR_LT
            end
        end

    end

end


-- =================== полезные вспомогательные фукции ===================

function Game:Over()

    pitchMod = 0.8 + love.math.random(0, 10)/25
    sound_gameover:setPitch(pitchMod)
    sound_gameover:play()

    lives = lives - 1
    if lives > 0 then
        -- почистить лишнее
        for i = 1, MAX_X do
            for j = 1, MAX_Y do
                if field[i][j] == F_TRACE then field[i][j] = F_NONE end
            end
        end
        player:Init()
        return
    end

    -- context = home
    context.switch(home)


    hiscore_ptr = 0
    if score > config.hiscore[#config.hiscore][1] then

        -- обновить таблицу результатов
        for i = #config.hiscore, 1, -1 do
            if config.hiscore[i][1] < score then hiscore_ptr = i end
        end
        HiScore:New()
    end

    Dialog:New('GAME ', 'OVER!')

end


function Game:make_field(level)

    -- инициализация поля
    field = {}
    for i = 1, MAX_X do
        field[i] = {}
        for j = 1, MAX_Y do
            if  i < 3  or  i > MAX_X-2 or
                j < 3  or  j > MAX_Y-2 then
                field[i][j] = F_FILL
            else
                field[i][j] = F_NONE
            end
        end
    end

    -- инициализация бегающих точек в заполненной части
    indots = {}
    for i = 1, level do
        indots[i] = Dot:New(math.random(MAX_X), MAX_Y, DOT_SPEED + math.random(DOT_SPEED_VAR), F_FILL)
    end
    -- и в поле
    outdots = {}
    for i = 1, level+1 do
        outdots[i] = Dot:New(math.random(MAX_X-4)+2, math.random(MAX_Y-4)+2, 
                             DOT_SPEED + math.random(DOT_SPEED_VAR), F_NONE)
    end

    player = Player:New(PLAYER_SPEED)

    filled = 0
    filledp = 0

end


function print_field()
    for i = 1, MAX_X do
        for j = 1, MAX_Y do
            io.write(field[i][j])
        end
        io.write("\n")
    end
    io.flush()
end



