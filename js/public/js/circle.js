/**
 * Construct the Circle class with name, location, size, color, and drawing context.
 * @class Class representing a circle to be drawn on the canvas.
 */
function Circle(id, loc, radius, color, ctx) {
    this.id = id
    this.x = loc[0]
    this.y = loc[1]
    this.radius = radius
    this.color = color
    this.ctx = ctx
}

Circle.prototype.draw = function() {
    ctx.beginPath()
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI*2, true)
    ctx.closePath()
    ctx.fillStyle = this.color
    ctx.fill()
}

Circle.prototype.resize = function(factor) {
    this.radius = this.radius * factor
}

/**
 * Check if the object is being click on.
 * @param {int} x X location of the click event.
 * @param {int} y Y location of the click event.
 */
Circle.prototype.isClicked = function(x, y) {
    dist = (x - this.x)*(x - this.x) + (y - this.y)*(y - this.y)
    return dist <= (this.radius*this.radius)
}