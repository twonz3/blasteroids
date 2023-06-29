HUD = Object:extend()

local fontSizeMedium = 18
local fontSizeLarge = 24
local fontSizeXLarge = 32
local lineHeight = 20
local topOffsetLeft = 80 -- sets the offset of the left HUD's top from the bottom of the screen
local topOffsetRight = 80 -- sets the offset of the right HUD's top from the bottom of the screen
local alphaFill = 0.8 -- alpha for HP/progress bar fill
local barHeight = 16
local image_hp10 = love.graphics.newImage("img/powerup_pillRed.png")
local image_weapon1Up = love.graphics.newImage("img/powerup_boltGold.png")

function HUD:new()
    
end


function HUD:draw()
    
    -- Gameplay
    if gameState.play == true then
        self:drawHUD()
    end

    -- Menu screen
    if gameState.menu == true then
        self:drawMenu()
    end
    
    -- Pause screen
    if gameState.pause == true then
        self:drawHUD()
        self:drawPause()
    
    -- Game over screen
    elseif gameState.gameover == true then
        self:drawHUD()
        self:drawGameover()
    end
end


-- Draws the main gameplay HUD
function HUD:drawHUD()

    love.graphics.setNewFont(fontSizeMedium)

    -- Left HUD
    -- HP bar
    love.graphics.print("HP: " .. string.format("%.0f", player.hp), 20, H - topOffsetLeft)
    if player.hp <= 20 then
        love.graphics.setColor(0.8, 0, 0, alphaFill)
    elseif player.hp <= 50 then
        love.graphics.setColor(0.8, 0.8, 0, alphaFill)
    else
        love.graphics.setColor(0, 0.8, 0, alphaFill)
    end
    love.graphics.rectangle("fill", 20, H - topOffsetLeft + lineHeight + 2, 200 * (player.hp / player.maxhp), barHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 20, H - topOffsetLeft + lineHeight + 2, 200, barHeight)
    -- Weapon 1 info
    love.graphics.print("[" .. KeyWeapon1 .. "] " .. player.weapon1 .. " +" .. player.weapon1Lvl, 20, H - topOffsetLeft + lineHeight*2)
            
    -- Right HUD
    -- Player level
    love.graphics.print("Lvl. " .. player.playerLvl, W - 240, H - topOffsetRight)
    -- Next level progress bar
    love.graphics.setColor(1, 1, 1, alphaFill)
    love.graphics.rectangle("fill", W - 240, H - topOffsetRight + lineHeight + 2, 200 * (math.min(player.score, levelScoreList[player.playerLvl + 1]) - levelScoreList[player.playerLvl]) / (levelScoreList[player.playerLvl + 1] - levelScoreList[player.playerLvl]), barHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", W - 240, H - topOffsetRight + lineHeight + 2, 200, barHeight)
    -- Score
    love.graphics.print("Score: " .. player.score, W - 240, H - topOffsetRight + lineHeight*2)

end


-- Draws the main menu screen
function HUD:drawMenu()

    local titleY = H/5
    local menuY = titleY + 6*fontSizeXLarge
    local menuX = W/6

    -- Set the player level and enemy spawn period to play in the background of the menu
    player.playerLvl = 9
    spawn.enemySpawnPeriod = enemySpawnPeriodList[9]
    
    love.graphics.setNewFont(fontSizeXLarge)
    love.graphics.printf("BLASTEROIDS", 0, titleY, W, "center")
    love.graphics.setNewFont(fontSizeLarge)
    love.graphics.printf("An Asteroid Shooting Game (for CS50)", 0, titleY + 2*fontSizeXLarge, W, "center")

    love.graphics.setNewFont(fontSizeMedium)
    love.graphics.printf(
        "Powerups: \n\n" .. 
        "\t\t\tRestore HP\n\n" .. 
        "\t\t\tUpgrade laser\n\n" ..
        "Controls: \n\n" .. 
        "\t[" .. KeyLeft .. "]\tMove left\n" .. 
        "\t[" .. KeyRight .. "]\tMove right\n" ..
        "\t[" .. KeyUp .. "]\tMove up\n" ..
        "\t[" .. KeyDown .. "]\tMove down\n" ..
        "\t[" .. KeyWeapon1 .. "]\tFire laser\n\n" ..
        "\t[" .. KeyPause .. "]\tPause\n\n" ..
        "\t[" .. KeyStartGame .. "]\tStart new game",
        menuX, menuY, W, "left")
    love.graphics.draw(image_hp10, menuX + 20, menuY + 2.2*fontSizeMedium)
    love.graphics.draw(image_weapon1Up, menuX + 20, menuY + 4.4*fontSizeMedium)

end


function HUD:drawPause()
    love.graphics.setNewFont(fontSizeLarge)
    love.graphics.printf("GAME PAUSED", 0, H/4, W, "center")
    love.graphics.setNewFont(fontSizeMedium)
    love.graphics.printf("[" .. KeyPause .. "] to resume", 0, H/4 + 2*fontSizeLarge, W, "center")
end


function HUD:drawGameover()
    love.graphics.setNewFont(fontSizeLarge)
    love.graphics.printf("GAME OVER", 0, H / 4, W, "center")
    love.graphics.setNewFont(fontSizeMedium)
    love.graphics.printf("[" .. KeyStartGame .. "] to play again", 0, H/4 + 2*fontSizeLarge, W, "center")
end