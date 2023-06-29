-- Launch configuration for debugging
if arg[2] == "debug" then
    require("lldebugger").start()
end
-- Instant output to debug console with print() command
io.stdout:setvbuf("no")

-- Imports
Object = require "classic"
require "gfx"
require "player"
require "spawn"
require "enemies"
require "powerups"
require "weapons"
require "hud"
require "notify"
require "devConsole"

function love.load()
    
    -- Init window properties
    H = 1080
    W = H * 1.25
    love.window.setMode(W, H)
    love.window.setPosition(1000, 120, 1)
    love.graphics.setBackgroundColor(0, 0, 0.075)
    devConsole = DevConsole()
    showDevConsole = false

    -- Init controls
    KeyLeft, KeyRight, KeyUp, KeyDown, KeyWeapon1, KeyWeapon2 = "a", "d", "w", "s", "space", "b"
    KeyPause, KeyStartGame = "escape", "return"
    KeyDevConsole = "`"
    
    -- Init game constants
    MAX_PLAYER_LEVEL = 100
    MAX_WEAPON1_LEVEL = 10
    MIN_ENEMY_SPAWN_PERIOD = 0.2
    START_LEVEL_meteorBrown = 1
    START_LEVEL_meteorGrey = 5
    
    -- Init list of scores needed to reach each level
    levelScoreList = {}
    levelScoreList[1] = 0
    levelScoreList[2] = 80
    for i = 3, MAX_PLAYER_LEVEL do
        levelScoreList[i] = math.ceil( levelScoreList[i-1] + levelScoreList[2] + 20 * (i-2))
    end
    
    -- Init list of spawn chances of "meteorGrey" by level
    meteorGreySpawnList = {}
    for i = 1, START_LEVEL_meteorGrey - 1 do
        meteorGreySpawnList[i] = 0
    end
    for i = START_LEVEL_meteorGrey, MAX_PLAYER_LEVEL do
        meteorGreySpawnList[i] = 0.2 + (0.5 - 0.2) / (MAX_PLAYER_LEVEL - START_LEVEL_meteorGrey) * (i - START_LEVEL_meteorGrey)
    end
    
    -- Init list of spawn chances of "meteorBrown" by level
    meteorBrownSpawnList = {}
    for i = 1, MAX_PLAYER_LEVEL do
        meteorBrownSpawnList[i] = 1 - meteorGreySpawnList[i]
    end
    
    -- Init list of enemy spawn rates by level
    enemySpawnPeriodList = {}
    for i = 1, MAX_PLAYER_LEVEL do
        enemySpawnPeriodList[i] = math.max(2.5 - 0.15 * (i - 1), MIN_ENEMY_SPAWN_PERIOD)
    end
    
    -- Init list of Weapon1 cooldown periods by Weapon1 level
    weapon1CooldownList = {}
    for i = 1, MAX_WEAPON1_LEVEL do
        weapon1CooldownList[i] = 0.48 - 0.03 * (i - 1)
    end

    -- Init list of game states
    gameState = {play = false, pause = false, menu = true, gameover = false}

    -- Init game objects
    startGame()

end


function love.update(dt)
    
    -- Main gameplay state
    if gameState.play == true then
        
        -- Move player, decrement weapon timers, shoot weapons (if timer reached), check levelup
        player:update(dt)

        -- Update spawn timers, spawn new enemy and/or powerup (if timer reached)
        spawn:update(dt)

        -- Check if enemy is dead, move enemy, set enemy dead if offscreen; check collision with player; remove dead enemies
        for i = #enemyList, 1, -1 do
            enemyList[i]:update(dt)
            enemyList[i]:checkCollision(player)
            if enemyList[i].dead == true then
                table.remove(enemyList, i)
            end
        end
        
        -- Move weapon, set weapon dead if offscreen; check collision with each enemy; remove dead weapons
        for i = #weaponList, 1, -1 do
            weaponList[i]:update(dt)
            for j = #enemyList, 1, -1 do
                weaponList[i]:checkCollision(enemyList[j])
            end
            if weaponList[i].dead == true then
                table.remove(weaponList, i)
            end
        end

        -- Move powerup, set powerup dead if offscreen; check collision with player; remove dead powerups
        for i = #powerupList, 1, -1 do
            powerupList[i]:update(dt)
            powerupList[i]:checkCollision(player)
            if powerupList[i].dead == true then
                table.remove(powerupList, i)
            end
        end

        -- Update gfx, remove dead gfx
        for i = #gfxList, 1, -1 do
            gfxList[i]:update(dt)
            if gfxList[i].dead == true then
                table.remove(gfxList, i)
            end
        end

        -- Update notify messages, remove dead messages
        for i = #notifyList, 1, -1 do
            notifyList[i]:update(dt)
            if notifyList[i].dead == true then
                table.remove(notifyList, i)
            end
        end
        
        -- Check for gameover
        if player.dead == true then
            gameState = {play = false, pause = false, menu = false, gameover = true}
        end
           
    -- Pause state
    elseif gameState.pause == true then
        
    -- Menu state
    elseif gameState.menu == true then

        -- Update spawn timers, spawn new enemy and/or powerup (if timer reached)
        spawn:update(dt)

        -- Check if enemy is dead, move enemy, set enemy dead if offscreen; remove dead enemies
        for i = #enemyList, 1, -1 do
            enemyList[i]:update(dt)
            if enemyList[i].dead == true then
                table.remove(enemyList, i)
            end
        end
        
    -- Gameover state
    elseif gameState.gameover == true then

        -- Update spawn timers, spawn new enemy and/or powerup (if timer reached)
        spawn:update(dt)

        -- Check if enemy is dead, move enemy, set enemy dead if offscreen; remove dead enemies
        for i = #enemyList, 1, -1 do
            enemyList[i]:update(dt)
            if enemyList[i].dead == true then
                table.remove(enemyList, i)
            end
        end
        
        -- Move weapon, set weapon dead if offscreen; check collision with each enemy; remove dead weapons
        for i = #weaponList, 1, -1 do
            weaponList[i]:update(dt)
            for j = #enemyList, 1, -1 do
                weaponList[i]:checkCollision(enemyList[j])
            end
            if weaponList[i].dead == true then
                table.remove(weaponList, i)
            end
        end
        
        -- Update gfx, remove dead gfx
        for i = #gfxList, 1, -1 do
            gfxList[i]:update(dt)
            if gfxList[i].dead == true then
                table.remove(gfxList, i)
            end
        end

        -- Update notify messages, remove dead messages
        for i = #notifyList, 1, -1 do
            notifyList[i]:update(dt)
            if notifyList[i].dead == true then
                table.remove(notifyList, i)
            end
        end

    end

end


function love.draw()
    
    -- Dev console
    if showDevConsole == true then
        devConsole:draw()
    end
    
    -- Main gameplay state
    if gameState.play == true then
        
        for i = #weaponList, 1, -1 do
            weaponList[i]:draw()
        end
        for i = #enemyList, 1, -1 do
            enemyList[i]:draw()
        end
        for i = #gfxList, 1, -1 do
            gfxList[i]:draw()
        end
        for i = #powerupList, 1, -1 do
            powerupList[i]:draw()
        end        
        player:draw()
        for i = #notifyList, 1, -1 do
            notifyList[i]:draw()
        end
        hud:draw()
            
    -- Pause state
    elseif gameState.pause == true then

        for i = #weaponList, 1, -1 do
            weaponList[i]:draw()
        end
        for i = #enemyList, 1, -1 do
            enemyList[i]:draw()
        end
        for i = #gfxList, 1, -1 do
            gfxList[i]:draw()
        end
        for i = #powerupList, 1, -1 do
            powerupList[i]:draw()
        end
        player:draw()
        for i = #notifyList, 1, -1 do
            notifyList[i]:draw()
        end
        hud:draw()
        
        
    -- Menu state
    elseif gameState.menu == true then

        for i = #enemyList, 1, -1 do
            enemyList[i]:draw()
        end        
        hud:draw()
        
    
    -- Gameover state
    elseif gameState.gameover == true then

        for i = #weaponList, 1, -1 do
            weaponList[i]:draw()
        end
        for i = #enemyList, 1, -1 do
            enemyList[i]:draw()
        end
        for i = #gfxList, 1, -1 do
            gfxList[i]:draw()
        end
        for i = #notifyList, 1, -1 do
            notifyList[i]:draw()
        end
        hud:draw()
        
    end

end


function love.keypressed(key)
    
    if key == KeyDevConsole then
        if showDevConsole == false then
            showDevConsole = true
        else
            showDevConsole = false
        end
    end
    if key == KeyPause then
        if gameState.play == true then
            gameState.pause = true
            gameState.play = false
        elseif gameState.pause == true then
            gameState.play = true
            gameState.pause = false
        end
    end
    if key == KeyStartGame then
        if gameState.menu == true then
            gameState = {play = true, pause = false, menu = false, gameover = false}
            startGame()
        end
        if gameState.gameover == true then
            gameState = {play = true, pause = false, menu = false, gameover = false}
            startGame()
        end
    end
end


-- Init game objects 
function startGame()
    player = Player()
    spawn = Spawn()
    enemyList = {} -- Array of Enemy objects
    powerupList = {} -- Array of Powerup objects
    weaponList = {} -- Array of Weapon objects
    gfxList = {} -- Array of GFX objects
    notifyList = {} -- Array of Notify objects
    hud = HUD()
end
