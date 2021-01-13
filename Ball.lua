Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.w = width
    self.h = height

    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    if self.dx > 0 then
        self.x = math.min(self.x + self.dx * dt, WINDOW_WIDTH - 40 - self.w)
    elseif self.dx < 0 then
        self.x = math.max(self.x + self.dx * dt, 40)
    elseif self.dy > 0 then
        self.y = math.min(self.y + self.dy * dt, WINDOW_HEIGHT - 40 - self.h)
    elseif self.dy < 0 then
        self.y = math.max(self.y + self.dy * dt, 40)
    end
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

