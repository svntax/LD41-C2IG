extends Area2D

var finishedLevel
var finishLevelUI

func _ready():
    finishedLevel = false
    finishLevelUI = get_parent().find_node("FinishLevelUI")

func _on_ExitArea_body_entered(body):
    #print("Physics body entered:")
    #print(body)
    var player = get_parent().find_node("PlayerRoot").find_node("PlayerKinematicBody");
    if body==player:
        #print("Player entered Exit Zone");
        if(not finishedLevel):
            finishedLevel = true
            Globals.levelFinished = true
            if(not SoundHandler.victorySound.playing):
                SoundHandler.victorySound.play()
            finishLevelUI.show()
            finishLevelUI.updateTimeStat()
            if(SoundHandler.walkingSound.playing):
                SoundHandler.walkingSound.stop()
            if(SoundHandler.drivingSound.playing):
                SoundHandler.drivingSound.stop()
            get_tree().paused = true