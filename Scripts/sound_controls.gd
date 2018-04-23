extends Node

var walkingSound
var victorySound
var drivingSound
var hurtSound
var gameOverMelody
var mainMenuTheme

func _ready():
    walkingSound = find_node("WalkingSound")
    victorySound = find_node("VictorySound")
    drivingSound = find_node("DrivingSound")
    hurtSound = find_node("HurtSound")
    gameOverMelody = find_node("GameOverMelody")
    mainMenuTheme = find_node("MainMenuTheme")