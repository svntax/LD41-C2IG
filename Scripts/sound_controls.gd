extends Node

var walkingSound
var victorySound
var drivingSound
var hurtSound

func _ready():
    walkingSound = find_node("WalkingSound")
    victorySound = find_node("VictorySound")
    drivingSound = find_node("DrivingSound")
    hurtSound = find_node("HurtSound")