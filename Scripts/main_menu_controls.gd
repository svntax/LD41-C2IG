extends VBoxContainer

func _ready():
    SoundHandler.mainMenuTheme.play()

func _on_StartButton_pressed():
    SoundHandler.mainMenuTheme.stop()
    get_tree().change_scene("res://Scenes/gameplay.tscn")

func _on_QuitButton_pressed():
    get_tree().quit()
