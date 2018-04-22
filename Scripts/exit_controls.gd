extends Area2D

func _ready():
    pass

func _on_ExitArea_body_entered(body):
    print("Physics body entered:")
    print(body)
