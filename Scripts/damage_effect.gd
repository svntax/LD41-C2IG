extends ColorRect

func _ready():
    pass

func toggleEffect():
    find_node("Timer").start()
    self.show()

func _on_Timer_timeout():
    self.hide()
