Spawn = Object:extend()

function Spawn:new()
    
    -- Spawn buffer = the distance offscreen an object spawns
    self.spawnBufferX = 50
    self.spawnBufferY = 50
    
    -- Death buffer = the distance offscreen until an object dies
    self.deathBufferX = 200
    self.deathBufferY = 200
    
    -- Init spawn rates and timers
    self.enemySpawnPeriod = enemySpawnPeriodList[player.playerLvl]
    self.enemySpawnTimer = self.enemySpawnPeriod
    self.powerupSpawnPeriod = 14
    self.powerupSpawnTimer = self.powerupSpawnPeriod

end


function Spawn:update(dt)

    -- Spawn new enemy when timer hits zero
    if self.enemySpawnTimer <= 0 then
        self:spawnEnemy()
    end

    -- Spawn new powerup when timer hits zero
    if self.powerupSpawnTimer <= 0 then
        self:spawnPowerup()
    end

    -- Decrement spawn timers
    if self.enemySpawnTimer > 0 then
        self.enemySpawnTimer = self.enemySpawnTimer - dt
    end
    if self.powerupSpawnTimer > 0 then
        self.powerupSpawnTimer = self.powerupSpawnTimer - dt
    end

end


function Spawn:spawnEnemy()
    
    local randEnemy = love.math.random()
    local enemyType = ""
    if randEnemy < meteorGreySpawnList[player.playerLvl] then
        enemyType = "meteorGrey"
    else
        enemyType = "meteorBrown"
    end
    
    table.insert(enemyList, Enemy(love.math.random(self.spawnBufferX, W-self.spawnBufferX), -self.spawnBufferY, enemyType, player.playerLvl))
    
    -- After enemy spawns, reset spawn timer to the spawn period +/- a random offset
    self.enemySpawnTimer = self.enemySpawnPeriod + (love.math.random() - 0.5) * (0.2 * self.enemySpawnPeriod)
end


function Spawn:spawnPowerup()
    
    local powerupType = ""    
    if player.weapon1Lvl < math.ceil(player.playerLvl/5) then
        powerupType = "weapon1Up"
    else
        powerupType = "hp10"
    end
    
    table.insert(powerupList, Powerup(love.math.random(self.spawnBufferX, W-self.spawnBufferX), -self.spawnBufferY, powerupType))
    
    -- After powerup spawns, reset spawn timer to the spawn period
    self.powerupSpawnTimer = self.powerupSpawnPeriod

end

