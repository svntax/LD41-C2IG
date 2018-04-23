extends RigidBody2D

var playerRootNode

func _ready():
    #Works because by the time this code runs, the player node
    #has already been created, so index 0 is a valid index
    playerRootNode = get_tree().get_nodes_in_group("players")[0]
    print(playerRootNode)

#General update loop
func _process(delta):
    pass

#Update loop for handling anything physics related
func _physics_process(delta):
    pass

func _on_WanderTimer_timeout():
    var offset = Vector2(randi() % 16, randi() % 16)
    var impulse = Vector2(randi() % 30, randi() % 30)
    self.apply_impulse(offset, impulse)
