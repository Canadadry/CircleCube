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

function DrawLine(l, x, y, w, h)
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
end

function DrawTable(t, x, y)
    love.graphics.clear(0, 0, 0)
    DrawLine(t.line1, x, y, t.width, t.height)
    y = y + t.height + t.spacing
    DrawLine(t.line2, x, y, t.width, t.height)
end

function love.draw()
    love.graphics.clear(0, 0, 0)
    DrawTable(t, 0, 0)
end

function love.load()
end
