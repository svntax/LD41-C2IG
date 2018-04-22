extends Node2D

var terrainGenNode
export (int) var PIXEL_SIZE = 3
var toggled
var playerBody
var playerBlink

func _ready():
    terrainGenNode = get_parent().get_parent().find_node("TerrainGenerator")
    toggled = true
    playerBlink = 0
    playerBody = get_parent().get_parent().find_node("PlayerRoot").find_node("PlayerKinematicBody")

func _process(delta):
    update()
    if(Input.is_action_just_pressed("TOGGLE_MINIMAP")):
        toggled = not toggled
        if(toggled):
            self.show()
        else:
            self.hide()

func _draw():
    if(toggled and terrainGenNode):
        #Draw the solid tiles
        var w = terrainGenNode.WIDTH
        var h = terrainGenNode.HEIGHT
        for i in range(0, w):
            for j in range(0, h):
                if(terrainGenNode.binaryGrid[i][j] == 1):
                    var pixel = Rect2(i*PIXEL_SIZE, j*PIXEL_SIZE, PIXEL_SIZE, PIXEL_SIZE)
                    draw_rect(pixel, Color(0, 0, 0), true)
                else:
                    var pixel = Rect2(i*PIXEL_SIZE, j*PIXEL_SIZE, PIXEL_SIZE, PIXEL_SIZE)
                    draw_rect(pixel, Color(0.5, 0.5, 0.5), true)
        #Draw the player
        var playerPos = Vector2(playerBody.global_position.x / 32, playerBody.global_position.y / 32) * PIXEL_SIZE
        var playerPixel = Rect2(playerPos, Vector2(PIXEL_SIZE, PIXEL_SIZE))
        draw_rect(playerPixel, Color(1, playerBlink, playerBlink), true)


func _on_Timer_timeout():
    if(playerBlink == 1):
        playerBlink = 0
    else:
        playerBlink = 1
    update()
