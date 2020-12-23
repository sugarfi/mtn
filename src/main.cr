require "kemal"
require "celestine"

WIDTH = 800
HEIGHT = 400

MTN_DEPTH = 5
MTN_WIDTH = WIDTH / 2
MTN_HEIGHT = 200
MTN_Y = HEIGHT
MTN_COLORS = [
    "#3891a6",
    "#ffd166",
    "#4b2840",
    "#c04abc",
    "#e3655b"
]

SUN_COLOR = "red"
SUN_RINGS = 10
SUN_RADIUS = 100

SUNSET_DURATION = 120
SUNSET_COLORS = [
    "#fc9c54",
    "#fd5e53",
    "#4b3d60",
    "#152852" 
] of SIFNumber

STAR_COUNT = 100

r = Random.new

get "/" do
    Celestine.draw do |ctx|
        ctx.width = WIDTH
        ctx.width_units = "px"
        ctx.height = HEIGHT
        ctx.height_units = "px"

        ctx.rectangle do |r|
            r.x = 0
            r.y = 0
            r.width = WIDTH
            r.height = HEIGHT

            r.animate do |a|
                a.attribute = "fill"

                a.duration = SUNSET_DURATION
                a.duration_units = "s"

                a.values = SUNSET_COLORS

                a
            end

            r
        end

        STAR_COUNT.times do
            ctx.circle do |c|
                c.fill = "white"
                
                c.x = r.rand 0..WIDTH
                y = r.rand (HEIGHT // 2)..HEIGHT
                c.radius = 2

                c.animate do |a|
                    a.attribute = "cy"

                    a.freeze = true

                    a.duration = SUNSET_DURATION
                    a.duration_units = "s"

                    a.from = y
                    a.to = y - HEIGHT / 2

                    a
                end

                c
            end
        end

        ctx.circle do |c|
            c.fill = SUN_COLOR

            c.x = WIDTH / 2
            c.y = HEIGHT / 2
            c.radius = SUN_RADIUS

            c.animate do |a|
                a.attribute = "cy"

                a.freeze = true

                a.duration = SUNSET_DURATION
                a.duration_units = "s"

                a.from = HEIGHT / 2
                a.to = HEIGHT

                a
            end

            c
        end

        SUN_RINGS.times do |n|
            n2 = SUN_RINGS - n

            ctx.circle do |c|
                c.stroke = SUN_COLOR
                c.stroke_width = n2 / 3

                c.fill = "none"

                c.x = WIDTH / 2
                c.y = HEIGHT / 2
                
                c.radius = SUN_RADIUS + (n + 1) * 5 

                c.animate do |a|
                    a.attribute = "cy"

                    a.freeze = true

                    a.duration = SUNSET_DURATION
                    a.duration_units = "s"

                    a.from = HEIGHT / 2
                    a.to = HEIGHT

                    a
                end
                
                c
            end
        end

        MTN_DEPTH.times do |n|
            n = (MTN_DEPTH - 1) - n
            
            ctx.path do |p|
                p.fill = MTN_COLORS[n % MTN_COLORS.size]

                p.a_move MTN_WIDTH / 2 ** n - MTN_WIDTH, MTN_Y
                (3 * 2 ** n).times do |x|
                    p.r_line MTN_WIDTH / 2, -MTN_HEIGHT
                    p.r_line MTN_WIDTH / 2, MTN_HEIGHT
                    p.r_move -MTN_WIDTH, 0
                    p.r_move MTN_WIDTH / 2 ** n, 0
                end

                p
            end       
        end
    end
end

Kemal.run
