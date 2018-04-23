extends VBoxContainer

func _ready():
    pass

func _process(delta):
    if(Input.is_action_just_pressed("PAUSE")):
        if(self.is_visible_in_tree()):
            self.hide()
            get_tree().paused = false
        else:
            self.show()
            if(SoundHandler.walkingSound.playing):
                SoundHandler.walkingSound.stop()
            get_tree().paused = true

func _on_StartButton_pressed():
    get_tree().paused = false
    get_tree().change_scene("res://Scenes/main_menu.tscn")
