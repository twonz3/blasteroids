Player = Object:extend()

function Player:new()
    
    self.dead = false
    
    -- Init player graphics
    self.image = love.graphics.newImage("img/playerShip1.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.offsetX = self.width / 2
    self.offsetY = self.height / 2
    self.hurtTimer = 0
    
    -- Init player position and movement variables
    self.x = W / 2
    self.y = H - 100
    self.acc = 3000
    self.dec = 300
    self.velX = 0
    self.velY = 0
    self.maxSpeed = 420
    
    -- Init player hp, lvl and score variables
    self.maxhp = 100
    self.hp = self.maxhp
    self.playerLvl = 1
    self.score = 0

    -- Init player weapon variables
    self.weapon1 = "Laser" -- Valid value(s): "Laser"
    self.weapon1Lvl = 1
    self.weapon1Cooldown = weapon1CooldownList[self.weapon1Lvl]
    self.weapon1Timer = 0

end


function Player:update(dt)
    
    -- If player's hp is 0 or below, player dies
    if self.hp <= 0 then
        self.dead = true
    end
    
    -- Move player
    self:move(dt)

    -- Shoot weapons
    if love.keyboard.isDown(KeyWeapon1) and self.weapon1Timer <= 0 then
        self:shootWeapon1()
    end
    
    -- Decrement weapon cooldown timers
    if self.weapon1Timer > 0 then
        self.weapon1Timer = self.weapon1Timer - dt
    end

    -- Decrement gfx timers
    if self.hurtTimer > 0 then
        self.hurtTimer = self.hurtTimer - dt
    end

    -- Check if current score triggers levelup, and if so, process the levelup
    self:checkLevelUp()

end


function Player:draw()
    if self.hurtTimer > 0 then
        drawHurt(self, self.hurtTimer)
    else
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.offsetX, self.offsetY)
    end
end


-- read KeyRight, KeyLeft, KeyDown, KeyUp inputs and move player
function Player:move(dt)
    
    local deadZone = 10 -- threshhold to round small values of velX and velY to 0

    -- accelerate player on x-axis
    if love.keyboard.isDown(KeyRight) then
        self.velX = self.velX + self.acc * dt
    end
    if love.keyboard.isDown(KeyLeft) then
        self.velX = self.velX - self.acc * dt
    end
    -- if no x-axis acceleration is being applied, deccelerate back to 0
    if not love.keyboard.isDown(KeyRight) and not love.keyboard.isDown(KeyLeft) then
        if self.velX > deadZone then
            self.velX = self.velX - self.dec * dt
        elseif self.velX < -deadZone then
            self.velX = self.velX + self.dec * dt
        else
            self.velX = 0
        end
    end
    -- cap velX at maxSpeed
    if self.velX > self.maxSpeed then
        self.velX = self.maxSpeed
    elseif self.velX < -self.maxSpeed then
        self.velX = -self.maxSpeed
    end

    -- accelerate player on y-axis
    if love.keyboard.isDown(KeyDown) then
        self.velY = self.velY + self.acc * dt
    end
    if love.keyboard.isDown(KeyUp) then
        self.velY = self.velY - self.acc * dt
    end
    -- if no x-axis acceleration is being applied, deccelerate back to 0
    if not love.keyboard.isDown(KeyDown) and not love.keyboard.isDown(KeyUp) then
        if self.velY > deadZone then
            self.velY = self.velY - self.dec * dt
        elseif self.velY < -deadZone then
            self.velY = self.velY + self.dec * dt
        else
            self.velY = 0
        end
    end
    -- cap velY at maxSpeed
    if self.velY > self.maxSpeed then
        self.velY = self.maxSpeed
    elseif self.velY < -self.maxSpeed then
        self.velY = -self.maxSpeed
    end

    -- apply velX and velY to player's position
    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt

    -- check for x-axis OOB collision, put player back in bounds and set velX to 0
    if self.x < self.offsetX then
        self.x = self.offsetX
        self.velX = 0
    elseif self.x > W - self.offsetX then
        self.x = W - self.offsetX
        self.velX = 0
    end

    -- check for y-axis OOB collision, put player back in bounds and set velY to 0
    if self.y < self.offsetY then
        self.y = self.offsetY
        self.velY = 0
    elseif self.y > H - self.offsetY then
        self.y = H - self.offsetY
        self.velY = 0
    end
end


-- Add new instance of Weapon1 and reset cooldown timer
function Player:shootWeapon1()
    table.insert(weaponList, Weapon(self.x, self.y, self.weapon1, self.weapon1Lvl))
    self.weapon1Timer = self.weapon1Cooldown
end


function Player:checkLevelUp()
    
    -- If player is below the max level...
    if self.playerLvl < MAX_PLAYER_LEVEL then
        
        -- If score exceeds the score needed for the next level...
        if self.score >= levelScoreList[self.playerLvl + 1] then
            
            -- Increment player level
            self.playerLvl = self.playerLvl + 1
            
            -- Increment spawn timer
            spawn.enemySpawnPeriod = enemySpawnPeriodList[self.playerLvl]
            
        end
    end
end