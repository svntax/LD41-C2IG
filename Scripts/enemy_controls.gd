extends RigidBody2D

var playerRootNode

func _ready():
    #Works because by the time this code runs, the player node
    #has already been created, so index 0 is a valid index
    playerRootNode = get_tree().get_nodes_in_group("players")[0]
    #print(playerRootNode)

#General update loop
func _process(delta):
    pass

#Update loop for handling anything physics related
func _physics_process(delta):
    pass

func _on_WanderTimer_timeout():
    #var offset = Vector2(randi() % 16, randi() % 16)
    var impulse;
    var MEANDER_MAG = 100;
    var JUMP_MAG = 200.0;
    var AGGRO_RANGE = 200.0;
    var offset = Vector2(0, 0)
    var playerPos = playerRootNode.find_node("PlayerKinematicBody").global_position;
    var myPos = self.global_position;
    var dx = playerPos[0] - myPos[0];
    var dy = playerPos[1] - myPos[1];
    var norm = pow(pow(dx,2.0) + pow(dy,2.0),0.5) 
    if norm < AGGRO_RANGE:
        var factor = JUMP_MAG / norm;
        impulse = Vector2(dx*factor, dy*factor);
    else:
        impulse = Vector2(randi() % MEANDER_MAG - MEANDER_MAG/2, randi() % MEANDER_MAG - MEANDER_MAG / 2)
    self.apply_impulse(offset, impulse)
    
