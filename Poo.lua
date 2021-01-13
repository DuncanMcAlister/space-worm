Poo = Class{}

function Poo:init(x, y, rad)
    self.x = x
    self.y = y
    self.rad = rad
end

function Poo:render()
    love.graphics.circle('fill', self.x, self.y, self.rad)
end