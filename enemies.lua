Enemy = Object:extend()

function Enemy:new(x, y, enemyType, lvl)

    self.dead = false
    self.enemyType = enemyType
    self.lvl = lvl
    
    -- Implement "meteorBrown" enemy type
    if enemyType == "meteorBrown" then
        
        -- Init enemy image
        local rand = love.math.random(4)
        self.image = love.graphics.newImage("img/meteorBrown_big" .. rand .. ".png")
        
        -- Init enemy type-specific variables
        self.maxhp = 25
        self.hp = self.maxhp
        self.baseDmg = 10
        self.dmg = self.baseDmg
        self.baseSpeed = 100
        self.baseSpeedIncrease = 20
        self.points = self.maxhp
        
        -- Init enemy graphics variables
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
        self.offsetX = self.width / 2
        self.offsetY = self.height / 2
        self.viewAngle = love.math.random() * 2 * math.pi - math.pi
        self.hurtTimer = 0

        -- Init enemy position and movement variables
        self.x = x
        self.y = y
        self.x_dest = x
        self.y_dest = H + 100
        self.angle = math.atan2(self.y_dest - self.y, self.x_dest - self.x)
        self.cos = math.cos(self.angle)
        self.sin = math.sin(self.angle)
        self.speed = self.baseSpeed + self.baseSpeedIncrease * (lvl - 1)
        self.velX = self.cos * self.speed
        self.velY = self.sin * self.speed

    -- Implement "meteorGrey" enemy type
    elseif enemyType == "meteorGrey" then
        
        -- Init enemy image
        local rand = love.math.random(4)
        self.image = love.graphics.newImage("img/meteorGrey_big" .. rand .. ".png")
        
        -- Init enemy type-specific variables
        self.maxhp = 50
        self.hp = self.maxhp
        self.baseDmg = 15
        self.dmg = self.baseDmg
        self.baseSpeed = 100
        self.baseSpeedIncrease = 25
        self.points = self.maxhp
        
        -- Init enemy graphics variables
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
        self.offsetX = self.width / 2
        self.offsetY = self.height / 2
        self.viewAngle = love.math.random() * 2 * math.pi - math.pi
        self.hurtTimer = 0

        -- Init enemy position and movement variables
        self.x = x
        self.y = y
        self.x_dest = love.math.random(spawn.spawnBufferX, W-spawn.spawnBufferX)
        self.y_dest = H + 100
        self.angle = math.atan2(self.y_dest - self.y, self.x_dest - self.x)
        self.cos = math.cos(self.angle)
        self.sin = math.sin(self.angle)
        self.speed = self.baseSpeed + self.baseSpeedIncrease * (lvl - 1)
        self.velX = self.cos * self.speed
        self.velY = self.sin * self.speed

    end

end

function Enemy:update(dt)

    -- If enemy's hp is 0 or below, add its maxhp to player's score and enemy dies
    if self.hp <= 0 then
        self:kill()
    end
    
    -- Move enemy
    self:move(dt)

    -- Decrement gfx timers
    if self.hurtTimer > 0 then
        self.hurtTimer = self.hurtTimer - dt
    end

    -- Enemy dies if it leaves the screen
    if self.x < -spawn.deathBufferX or self.x > W+spawn.deathBufferX or self.y < -spawn.deathBufferY or self.y > H+spawn.deathBufferY then
        self.dead = true
    end

end


function Enemy:draw()

    if self.hurtTimer > 0 then
        drawHurt(self, self.hurtTimer)
    else
        love.graphics.draw(self.image, self.x, self.y, self.viewAngle, 1, 1, self.offsetX, self.offsetY)
    end

end


function Enemy:move(dt)

    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt

end


function Enemy:checkCollision(obj)
    local self_left = self.x - self.offsetX
    local self_right = self_left + self.width
    local self_top = self.y - self.offsetY
    local self_bottom = self_top + self.height

    local obj_left = obj.x - obj.offsetX
    local obj_right = obj_left + obj.width
    local obj_top = obj.y - obj.offsetY
    local obj_bottom = obj_top + obj.height

    local obj_safeBuffer = 20 -- adds safe buffer inside the edges of the obj's hurtbox

    -- If enemy collides with obj, decrease obj's hp (not below zero) by enemy's dmg and enemy dies 
    if (
        self_right > obj_left + obj_safeBuffer and
        self_left < obj_right - obj_safeBuffer and
        self_bottom > obj_top + obj_safeBuffer and
        self_top < obj_bottom - obj_safeBuffer)
    then
        obj.hp = math.max(obj.hp - self.dmg, 0)
        obj.hurtTimer = GFX_hurtPeriod
        self:kill()
    end
end


function Enemy:kill()
    player.score = player.score + self.points
    table.insert(notifyList, Notify(self.x, self.y, "+" .. self.points, {1, 1, 1}))
    table.insert(gfxList, GFX(self.x, self.y, "explode", self.enemyType, self.velX, self.velY))
    self.dead = true
end