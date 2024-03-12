Colors = {
    { r = 1, g = 0,   b = 0 },
    { r = 0, g = 1,   b = 0 },
    { r = 0, g = 0,   b = 1 },
    { r = 1, g = 1,   b = 0 },
    { r = 1, g = 0,   b = 1 },
    { r = 0, g = 1,   b = 1 },
    { r = 0, g = 0.5, b = 1 },
    { r = 1, g = 0.5, b = 0 },
}

function Piece(color, border)
    return {
        color = {
            r = color.r,
            g = color.g,
            b = color.b,
        },
        border = {
            r = border.r,
            g = border.g,
            b = border.b,
        }
    }
end

function Line(y, space, top, colors)
    l = {
        y = y,
        spacing = space,
        pieces = {},
        border = colors.border,
        draw = function(l, x, y, w, h)
            for i, v in ipairs(l.pieces) do
                love.graphics.setColor(v.border.r, v.border.g, v.border.b)
                love.graphics.rectangle("fill", x + (i - 1) * (w + l.spacing), y, w, h)
                love.graphics.setColor(v.color.r, v.color.g, v.color.b)
                love.graphics.rectangle(
                    "fill",
                    x + (i - 1) * (w + l.spacing) + l.border,
                    y + l.border,
                    w - 2 * l.border,
                    w - 2 * l.border
                )
            end
        end,
        rotateLeft = function(l)
            local tmp = l.pieces[1]
            local last = 1
            for i, v in ipairs(l.pieces) do
                if i > 1 then
                    last = i
                    l.pieces[i - 1] = l.pieces[i]
                end
            end
            l.pieces[last] = tmp
        end,
        rotateRight = function(l)
            local tmp = l.pieces[1]
            for i, v in ipairs(l.pieces) do
                if l.pieces[i + 1] then
                    local tmp2 = l.pieces[i + 1]
                    l.pieces[i + 1] = tmp
                    tmp = tmp2
                end
            end
            l.pieces[1] = tmp
        end,
    }
    for i, v in ipairs(colors.pieces) do
        l.pieces[i] = Piece(v, colors.line)
    end
    return l
end

function Table(xSpace, ySpace, line1, line2)
    local width = 100
    local height = 100
    return {
        spacing = ySpace,
        line1 = Line(0, xSpace, true, line1),
        line2 = Line(height + ySpace, xSpace, false, line2),
        width = width,
        height = height,
        draw = function(t, x, y)
            t.line1:draw(x, y, t.width, t.height)
            y = y + t.height + t.spacing
            t.line2:draw(x, y, t.width, t.height)
        end
        swap = function(t, x, w)

        end
    }
end

function Button(x, y, w, h, c, action)
    return {
        x = x,
        y = y,
        w = w,
        h = h,
        c = {
            r = c.r, g = c.g, b = c.b,
        },
        action = action,
        draw = function(b)
            love.graphics.setColor(b.c.r, b.c.g, b.c.b)
            love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
        end,
        trigger = function(b, x, y)
            if x < b.x then return end
            if y < b.y then return end
            if x > b.x + b.w then return end
            if y > b.y + b.h then return end
            if b.action then
                b.action()
            end
        end,
    }
end

t = Table(
    10,
    10,
    {
        line = Colors[7],
        pieces = { Colors[1], Colors[2], Colors[3], Colors[4], Colors[5], Colors[6] },
        border = 10,
    },
    {
        line = Colors[8],
        pieces = { Colors[1], Colors[2], Colors[3], Colors[4], Colors[5], Colors[6] },
        border = 10,
    }
)

actions = {
    Button(0, 12, 50, 50, Colors[1], function() t.line1:rotateLeft() end),
    Button(750, 12, 50, 50, Colors[1], function() t.line1:rotateRight() end),
    Button(0, 112, 50, 50, Colors[1], function() t.line2:rotateLeft() end),
    Button(750, 112, 50, 50, Colors[1], function() t.line2:rotateRight() end),
}

function love.draw()
    love.graphics.clear(0, 0, 0)
    t:draw(70, 0)
    for i, v in ipairs(actions) do
        v:draw()
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        for i, v in ipairs(actions) do
            v:trigger(x, y)
        end
    end
end
