extends VBoxContainer

func _ready():
    pass

func showGameOverUI():
    self.show()
    Globals.gameOver = true
    if(SoundHandler.walkingSound.playing):
        SoundHandler.walkingSound.stop()
    if(SoundHandler.drivingSound.playing):
        SoundHandler.drivingSound.stop()
    get_tree().paused = true

func _on_BackButton_pressed():
    get_tree().paused = false
    Globals.gameOver = false
    get_tree().change_scene("res://Scenes/main_menu.tscn")
