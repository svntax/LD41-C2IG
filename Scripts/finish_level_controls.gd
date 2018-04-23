extends VBoxContainer

var timeElapsed

func _ready():
    timeElapsed = 0

func _process(delta):
    timeElapsed += delta

func updateTimeStat():
    find_node("TimeLabel").text = "Time: %.3f seconds" % timeElapsed

func _on_NextButton_pressed():
    self.hide()
    get_tree().paused = false
    get_tree().reload_current_scene()
