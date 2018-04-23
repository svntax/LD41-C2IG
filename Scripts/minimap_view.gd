extends Node2D

var terrainGenNode
var PIXEL_SIZE = 1
var toggled
var playerBody
var playerBlink
var exit
var vehicles


func _ready():
    terrainGenNode = get_parent().get_parent().find_node("TerrainGenerator")
    toggled = true
    playerBlink = 0
    playerBody = get_parent().get_parent().find_node("PlayerRoot").find_node("PlayerKinematicBody")
    exit = get_parent().get_parent().find_node("ExitArea")
    vehicles = get_tree().get_nodes_in_group("vehicles")
    #print(vehicles);
    
     

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
        PIXEL_SIZE = 2;
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
        vehicles = get_tree().get_nodes_in_group("vehicles")
        for vehicle in vehicles:
            var vehiclePos = Vector2(vehicle.global_position.x / 32, vehicle.global_position.y / 32) * PIXEL_SIZE
            var vehiclePixel = Rect2(vehiclePos, Vector2(PIXEL_SIZE, PIXEL_SIZE))
            draw_rect(vehiclePixel, Color(0, 0, 1), true)
        #Draw the player
        var playerPos = Vector2(playerBody.global_position.x / 32, playerBody.global_position.y / 32) * PIXEL_SIZE
        var playerPixel = Rect2(playerPos, Vector2(PIXEL_SIZE, PIXEL_SIZE))
        draw_rect(playerPixel, Color(1, playerBlink, playerBlink), true)
        #Draw the exit
        var exitPos = Vector2(exit.global_position.x / 32, exit.global_position.y / 32) * PIXEL_SIZE
        var exitPixel = Rect2(exitPos, Vector2(PIXEL_SIZE, PIXEL_SIZE))
        draw_rect(exitPixel, Color(0, 1, 0), true)
        
            
        


func _on_Timer_timeout():
    if(playerBlink == 1):
        playerBlink = 0
    else:
        playerBlink = 1
    update()
