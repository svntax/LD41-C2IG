extends Area2D

func _ready():
    pass

func _on_ExitArea_body_entered(body):
    #print("Physics body entered:")
    #print(body)
    var player = get_parent().find_node("PlayerRoot").find_node("PlayerKinematicBody");
    if body==player:
        print("Player entered Exit Zone");