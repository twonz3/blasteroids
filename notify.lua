Notify = Object:extend()



function Notify:new(x, y, msg, fontColor) -- "fontColor" is an array, format {r, g, b}
    
    self.dead = false
    self.x = x
    self.y = y
    self.fontSize = 16
    self.msg = msg
    self.r = fontColor[1]
    self.g = fontColor[2]
    self.b = fontColor[3]
    self.maxalpha = 0.8
    self.alpha = self.maxalpha
    
    self.msgPeriod = 1.9
    self.msgTimer = self.msgPeriod
    self.fadePeriod = 0.25
    self.fadeTimer = self.fadePeriod
    self.maxSpeed = 40
    self.velX = 0
    self.velY = -self.maxSpeed


end


function Notify:update(dt)

    -- Move the message
    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt

    -- Decrement main message timer
    if self.msgTimer > 0 then
        self.msgTimer = self.msgTimer - dt
    end

    -- Decrement message fadeout timer and apply the alpha fadeout
    if self.msgTimer <= 0 and self.fadeTimer > 0 then
        self.fadeTimer = self.fadeTimer - dt
    end
    self.alpha = self.maxalpha * (self.fadeTimer / self.fadePeriod)

    -- Effect dies after the fadeout timer is over
    if self.fadeTimer <= 0 then
        self.dead = true
    end

end


function Notify:draw()

    love.graphics.setNewFont(self.fontSize)
    love.graphics.setColor(self.r, self.g, self.b, self.alpha)
    love.graphics.print(self.msg, self.x, self.y)
    love.graphics.setColor(GFX_mainColor)

end