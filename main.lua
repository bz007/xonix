--[[

    Classic Xonix LOVE implementation

]]--

MAX_X = 60
MAX_Y = 44

DOT_SPEED     = 10 -- клеток в секунду
DOT_SPEED_VAR = 10
PLAYER_SPEED  = 15

-- содержимое клеток на поле
F_NONE  = 0  -- пустая
F_FILL  = 1  -- заполненная
F_TRACE = 2  -- след от игрока
F_REST  = 3  -- в этой области есть точка

-- направления движения игрока
DIR_NO = 0
DIR_LT = 1
DIR_RT = 2
DIR_UP = 3
DIR_DN = 4

-- ================ игровые объекты ================================

require 'dot'
require 'player'
require 'game'
require 'home'
require 'dialog'

-- ================ главная часть ===========================

function love.load()

    -- love.window.setTitle('XoniX')
    math.randomseed(os.time())

    loadconfig()

    background_music = love.audio.newSource("res/bg00.ogg", "stream")
    -- background_music = love.audio.newSource("bg03.mp3", "stream")
    background_music:setLooping(true)
    background_music:setVolume(.2)
    love.audio.play(background_music)

    love.resize(love.graphics.getDimensions())

    game = Game:New()
    home = Home:New()

    -- начинаем с домашнего экрана
    context = home
end


function love.update(dt)
    context:Update(dt)
end


function love.draw()
    context:Draw()
end


function love.keypressed(key)
    context:Event(key)
end

ax = {}
function love.gamepadaxis(joystick, axis, value)
    ax[axis] = value
    -- print(string.format("Gamepad axis: %s, %s", axis, value))
end

local active_joystick
function love.gamepadpressed(joystick, button)

    if joystick == active_joystick then
        print(string.format("Gamepad button:%s.", button))
        return
    end
    active_joystick = joystick
    local name = joystick:getName()
    local index = joystick:getConnectedIndex()
    print(string.format("Changing active gamepad to #%d '%s' button:%s.", index, name, button))
end


-- ================ вспомогательные функции ========================

-- callback, вызывается при изметении размеров экрана
function love.resize(w, h)
    screen = {}
    screen.width, screen.height = w, h

    STAUS_LINE_H = screen.height / 30

    CELL_SIZE_X = math.floor(screen.width/MAX_X )
    CELL_SIZE_Y = math.floor((screen.height - STAUS_LINE_H)/MAX_Y)

    OFFSET_X    = (screen.width  - CELL_SIZE_X*MAX_X) / 2
    OFFSET_Y    = (screen.height - STAUS_LINE_H - CELL_SIZE_Y*MAX_Y) / 2

    fontH = love.graphics.newFont('res/Moulin.otf', screen.height/4)
    fontM = love.graphics.newFont('res/Moulin.otf', screen.height/8)
    fontS = love.graphics.newFont('res/Moulin.otf', STAUS_LINE_H)
    font  = love.graphics.newFont('res/Moulin.otf', screen.height/15)
end


function string:split(delimiter) --Not by me
    local result = {}
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
        table.insert( result, string.sub( self, from , delim_from-1 ) )
        from = delim_to + 1
        delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end


function saveconfig()
    local s = ""

    for i = 1, #hiscore do
        s = s .. hiscore[i]..';'
    end

    love.filesystem.write('xonix.ini', s)
end


function loadconfig()
    hiscore = {0,0,0,0,0}
    
    if love.filesystem.getInfo('xonix.ini') then

        local s = love.filesystem.read('xonix.ini')
        local p = s:split(';')

        for i = 1,#hiscore do
            hiscore[i] = tonumber(p[i])
        end
    end
end
