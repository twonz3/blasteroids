Powerup = Object:extend()

function Powerup:new(x, y, powerupType)

    self.dead = false
    self.powerupType = powerupType -- valid values: "hp10", "weapon1Up"

    -- Init "hp10" powerup type
    if powerupType == "hp10" then
        self.image = love.graphics.newImage("img/powerup_pillRed.png")
        self.points = 50

    -- Init "weapon1Up" powerup type
    elseif powerupType == "weapon1Up" then
        self.image = love.graphics.newImage("img/powerup_boltGold.png")
        self.points = 100

    end

    -- Init powerup graphics variables
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.offsetX = self.width / 2
    self.offsetY = self.height / 2

    -- Init powerup position and movement variables
    self.x = x
    self.y = y
    self.x_dest = x
    self.y_dest = H + 100
    self.angle = math.atan2(self.y_dest - self.y, self.x_dest - self.x)
    self.cos = math.cos(self.angle)
    self.sin = math.sin(self.angle)
    self.baseSpeed = 120
    self.speed = self.baseSpeed
    self.velX = self.cos * self.speed
    self.velY = self.sin * self.speed
end

function Powerup:update(dt)

    -- Move powerup
    self:move(dt)

    -- Powerup dies if it leaves the screen
    if self.x < -spawn.deathBufferX or self.x > W+spawn.deathBufferX or self.y < -spawn.deathBufferY or self.y > H+spawn.deathBufferY then
        self.dead = true
    end

end


function Powerup:draw()

    love.graphics.draw(self.image, self.x, self.y, 0, 1.5, 1.5, self.offsetX, self.offsetY)

end


function Powerup:move(dt)

    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt

end


function Powerup:checkCollision(obj)
    local self_left = self.x - self.offsetX
    local self_right = self_left + self.width
    local self_top = self.y - self.offsetY
    local self_bottom = self_top + self.height

    local obj_left = obj.x - obj.offsetX
    local obj_right = obj_left + obj.width
    local obj_top = obj.y - obj.offsetY
    local obj_bottom = obj_top + obj.height

    local obj_safeBuffer = 5 -- adds safe buffer inside the edges of the obj's hurtbox

    -- If powerup collides with obj, apply powerup and powerup dies
    if (
        self_right > obj_left + obj_safeBuffer and
        self_left < obj_right - obj_safeBuffer and
        self_bottom > obj_top + obj_safeBuffer and
        self_top < obj_bottom - obj_safeBuffer)
    then
        -- Implement "hp10" powerup effect
        if self.powerupType == "hp10" then
            player.hp = math.min(player.hp + 10, player.maxhp)
            table.insert(notifyList, Notify(self.x, self.y, "HP +10", {0, 1, 0}))
            table.insert(notifyList, Notify(self.x, self.y + 24, "+" .. self.points, {1, 1, 1}))
            
        -- Implement "weapon1Up" powerup effect
        elseif self.powerupType == "weapon1Up" then
            -- Increment Weapon1 level and update cooldown
            if player.weapon1Lvl < MAX_WEAPON1_LEVEL then
                player.weapon1Lvl = player.weapon1Lvl + 1
            end
            player.weapon1Cooldown = weapon1CooldownList[player.weapon1Lvl]
            table.insert(notifyList, Notify(self.x, self.y, "LASER +1", {0.5, 1, 1}))
            table.insert(notifyList, Notify(self.x, self.y + 24, "+" .. self.points, {1, 1, 1}))

        end

        player.score = player.score + self.points
        self.dead = true
    end
end