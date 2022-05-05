--[[

    Classic Xonix LOVE implementation

]]--

MAX_X = 60 -- ширина игрового поля
MAX_Y = 44 -- высота игрового поля

DOT_SPEED     = 10 -- скорость точек, клеток в секунду
DOT_SPEED_VAR = 10 -- вариация скорости
PLAYER_SPEED  = 15 -- скорость игрока

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
require 'hiscore'

-- ================ главная часть ===========================

function love.load()

    -- love.window.setTitle('XoniX')
    math.randomseed(os.time())

    loadconfig()

    background_music = love.audio.newSource("res/bg00.ogg", "stream")
    -- background_music = love.audio.newSource("bg03.mp3", "stream")
    background_music:setLooping(true)

    background_music:setVolume(config.volume)
    if config.music then love.audio.play(background_music) end

    love.window.setFullscreen(config.fullscreen)
    love.resize(love.graphics.getDimensions())

    game = Game:New()
    home = Home:New()

    -- начинаем с домашнего экрана

    context = require "gamestate"
    context.registerEvents()
    context.switch(home)

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

    fontH = love.graphics.newFont('res/Moulin.otf', screen.height/4)  -- huge
    fontM = love.graphics.newFont('res/Moulin.otf', screen.height/8)  -- medium
    font  = love.graphics.newFont('res/Moulin.otf', screen.height/18) -- usual
    fontS = love.graphics.newFont('res/Moulin.otf', STAUS_LINE_H)     -- status
end



function saveconfig()
    love.filesystem.write('xonix.cfg', serialize(config))
end


function loadconfig()
    config = {  hiscore={{0,1,"",""}, {0,1,"",""}, {0,1,"",""}, {0,1,"",""}, {0,1,"",""}},
                volume=.2, music=true, fullscreen=false, control="kbd", name="nobody"}
    
    if love.filesystem.getInfo('xonix.cfg') then

        local s = love.filesystem.read('xonix.cfg')
        local p = load("return "..s)()

        for k,v in pairs(p) do
            config[k] = v
        end
    end
end


function serialize(o, prefix)
    local pre = prefix or "  "
    local s = ""
    if type(o) == "number" or type(o) == "boolean" then
        s = s..tostring(o)
    elseif type(o) == "string" then
        s = s..string.format("%q", o)
    elseif type(o) == "table" then
        s = s.."{\n"
        for k,v in pairs(o) do
            s = s..pre.."["..serialize(k).."] = "..serialize(v, pre.."  ")..",\n"
        end
        s = s..pre.."}"
    else
        error("cannot serialize a " .. type(o))
    end
    return s
end


function noop() end
