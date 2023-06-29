DevConsole = Object:extend()

local fontSizeConsole = 12

function DevConsole:new()
    self.x = 20
    self.y = 200
    self.lineHeight = 20
end


function DevConsole:draw()
    love.graphics.setNewFont(fontSizeConsole)    
    love.graphics.print("DEV CONSOLE ([" .. KeyDevConsole .. "] to toggle)", self.x, self.y + self.lineHeight*0)
    
    love.graphics.print("x: " .. string.format("%.2f", player.x), self.x, self.y + self.lineHeight*1)
    love.graphics.print("y: " .. string.format("%.2f", player.y), self.x, self.y + self.lineHeight*2)
    love.graphics.print("player.playerLvl: " .. player.playerLvl, self.x, self.y + self.lineHeight*3)
    love.graphics.print("score for next level: " .. levelScoreList[player.playerLvl + 1], self.x, self.y + self.lineHeight*4)
    love.graphics.print("player.hp: " .. string.format("%.2f", player.hp), self.x, self.y + self.lineHeight*5)
    local weaponDmg = 0
    if #weaponList >= 1 then
        weaponDmg = weaponList[#weaponList].dmg
    else
        weaponDmg = 0
    end
    love.graphics.print("weapon1 dmg: " .. weaponDmg, self.x, self.y + self.lineHeight*6)
    love.graphics.print("weapon1 cooldown: ".. string.format("%.2f", player.weapon1Cooldown), self.x, self.y + self.lineHeight*7)
end