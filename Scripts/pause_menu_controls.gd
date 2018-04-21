extends VBoxContainer

func _ready():
    pass

func _process(delta):
    if(Input.is_action_just_pressed("PAUSE")):
        if(self.is_visible_in_tree()):
            self.hide()
        else:
            self.show()

func _on_StartButton_pressed():
    get_tree().change_scene("res://Scenes/main_menu.tscn")
