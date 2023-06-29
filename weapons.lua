Weapon = Object:extend()

function Weapon:new(x, y, weaponType, lvl)
    
    self.dead = false
    self.weaponType = weaponType
    self.lvl = lvl

    if self.weaponType == "Laser" then
        
        self.baseSpeed = 800
        self.baseDmg = 10
        self.spacing = 10
                
        -- Init level-specific variables
        if self.lvl == 1 then
            
            self.image = love.graphics.newImage("img/laser01.png")
            self.speed = self.baseSpeed
            self.count = 1
            self.dmg = self.baseDmg + self.baseDmg * (self.lvl - 1)

        elseif self.lvl == 2 then
            
            self.image = love.graphics.newImage("img/laser02.png")
            self.speed = self.baseSpeed + 100
            self.count = 2
            self.dmg = self.baseDmg + self.baseDmg * (self.lvl - 1)
        
        elseif self.lvl == 3 then
            
            self.image = love.graphics.newImage("img/laser03.png")
            self.speed = self.baseSpeed + 250
            self.count = 3
            self.dmg = self.baseDmg + self.baseDmg * (self.lvl - 1)
        
        elseif self.lvl == 4 then
            
            self.image = love.graphics.newImage("img/laser04.png")
            self.speed = self.baseSpeed + 400
            self.count = 3
            self.dmg = self.baseDmg + self.baseDmg * (self.lvl - 1)

        elseif self.lvl >= 5 then
            
            self.image = love.graphics.newImage("img/laser05.png")
            self.speed = self.baseSpeed + 450
            self.count = 3
            self.dmg = self.baseDmg + self.baseDmg * (self.lvl - 1)

        end
    
        -- Weapon variables        
        self.width = self.image:getWidth() * self.count + self.spacing * (self.count - 1)
        self.height = self.image:getHeight()
        self.x = x - self.width / 2
        self.y = y - self.height
    
    end
end


function Weapon:update(dt)
    
    -- Move weapon
    self:move(dt)
    
    -- Weapon dies if it leaves the screen
    if self.y < -200 then
        self.dead = true
    end
end


function Weapon:draw()
    if self.weaponType == "Laser" then

        love.graphics.setColor(1, 1, 1, 0.8)
        for i = 1, self.count do
            love.graphics.draw(self.image, self.x + self.image:getWidth() * (i - 1) + self.spacing * (i - 1), self.y)
        end
        love.graphics.setColor(1, 1, 1, 1)

    end
end


function Weapon:move(dt)
    self.y = self.y - self.speed * dt
end


function Weapon:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x - obj.offsetX
    local obj_right = obj_left + obj.width
    local obj_top = obj.y - obj.offsetY
    local obj_bottom = obj_top + obj.height

    local self_safeBuffer = 10 -- adds safe buffer inside the edges of the weapon's hitbox

    -- if weapon collides with obj, decrease obj's hp (not below zero) by weapon's dmg and weapon dies 
    if (
        self_right - self_safeBuffer > obj_left and
        self_left + self_safeBuffer < obj_right and
        self_bottom - self_safeBuffer > obj_top and
        self_top + self_safeBuffer < obj_bottom )
    then
        obj.hp = math.max(obj.hp - self.dmg, 0)
        obj.hurtTimer = GFX_hurtPeriod
        self.dead = true
    end
end