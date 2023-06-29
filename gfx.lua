GFX = Object:extend()

-- Init gfx constants
GFX_mainColor = {1.0, 1.0, 1.0, 1.0}
GFX_hurtColor = {1.0, 0.2, 0.0, 1.0}
GFX_hurtPeriod = 0.75

function GFX:new(x, y, fxType, callerType, callerVelX, callerVelY)
    
    self.dead = false
    self.x = x
    self.y = y
    self.callerType = callerType -- the type of object that called the fx
    self.fxType = fxType -- valid inputs: "explode"
    self.maxalpha = 0.9
    self.alpha = self.maxalpha

    if self.fxType == "explode" then
        
        -- Set explosion properties
        if self.callerType == "meteorGrey" then
            self.numParticles = 14
        else
            self.numParticles = 7
        end
        self.explodePeriod = 0.6
        self.explodeTimer = self.explodePeriod
        self.fadePeriod = 0.4
        self.fadeTimer = self.fadePeriod
        self.radiusInner = 50
        self.radiusOuter = 320

        -- Set particle images
        if self.callerType == "meteorBrown" then
            self.image1 = love.graphics.newImage("img/meteorBrown_tiny1.png")
            self.image2 = love.graphics.newImage("img/meteorBrown_tiny2.png")
        elseif self.callerType == "meteorGrey" then
            self.image1 = love.graphics.newImage("img/meteorGrey_tiny1.png")
            self.image2 = love.graphics.newImage("img/meteorGrey_tiny2.png")
        end
        
        -- Init particle pieces
        self.particleList = {}
        for i = 1, self.numParticles do
            local p = {}
            
            local randImage = love.math.random(1, 2)
            if randImage == 1 then
                p.image = self.image1
            else
                p.image = self.image2
            end
            
            local randAngle = love.math.random() * 2 * math.pi - math.pi
            local randInnerDist = love.math.random(1, self.radiusInner)
            local randOuterDist = love.math.random(self.radiusInner + 1, self.radiusOuter)
            local cos = math.cos(randAngle)
            local sin = math.sin(randAngle)
            local x1  = self.x + cos * randInnerDist
            local y1 = self.y + sin * randInnerDist
            local x2 = self.x + cos * randOuterDist
            local y2 = self.y + sin * randOuterDist
            p.x = x1
            p.y = y1
            p.velX = (x2 - x1) / self.explodeTimer + callerVelX
            p.velY = (y2 - y1) / self.explodeTimer + callerVelY / 2

            table.insert(self.particleList, p)
        end
    end
    
end


function GFX:update(dt)

    -- Move each particle in the effect
    for i = #self.particleList, 1, -1 do
        self.particleList[i].x = self.particleList[i].x + self.particleList[i].velX * dt
        self.particleList[i].y = self.particleList[i].y + self.particleList[i].velY * dt
    end

    -- Decrement main effect display timer
    if self.explodeTimer > 0 then
        self.explodeTimer = self.explodeTimer - dt
    end

    -- Decrement effect fadeout timer and apply the alpha fadeout
    if self.explodeTimer <= 0 and self.fadeTimer > 0 then
        self.fadeTimer = self.fadeTimer - dt
    end
    self.alpha = self.maxalpha * (self.fadeTimer / self.fadePeriod)

    -- Effect dies after the fadeout timer is over
    if self.fadeTimer <= 0 then
        self.dead = true
    end

end


function GFX:draw()

    love.graphics.setColor(1, 1, 1, self.alpha)
    for i = #self.particleList, 1, -1 do
        love.graphics.draw(self.particleList[i].image, self.particleList[i].x, self.particleList[i].y)
    end
    love.graphics.setColor(GFX_mainColor)

end


-- Draws hurt version of obj for t = time remaining
function drawHurt(obj, t)

    local r = GFX_hurtColor[1] + (GFX_mainColor[1] - GFX_hurtColor[1]) * ((GFX_hurtPeriod - t) / GFX_hurtPeriod)
    local g = GFX_hurtColor[2] + (GFX_mainColor[2] - GFX_hurtColor[2]) * ((GFX_hurtPeriod - t) / GFX_hurtPeriod)
    local b = GFX_hurtColor[3] + (GFX_mainColor[3] - GFX_hurtColor[3]) * ((GFX_hurtPeriod - t) / GFX_hurtPeriod)
    local a = GFX_hurtColor[4]
    love.graphics.setColor(r, g, b, a)
    love.graphics.draw(obj.image, obj.x, obj.y, obj.viewAngle, 1, 1, obj.offsetX, obj.offsetY)
    love.graphics.setColor(GFX_mainColor)
end



