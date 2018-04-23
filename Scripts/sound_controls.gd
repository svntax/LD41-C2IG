extends Node

var walkingSound
var victorySound
var drivingSound

func _ready():
    walkingSound = find_node("WalkingSound")
    victorySound = find_node("VictorySound")
    drivingSound = find_node("DrivingSound")