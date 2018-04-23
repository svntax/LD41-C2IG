extends Node

var walkingSound
var victorySound

func _ready():
    walkingSound = find_node("WalkingSound")
    victorySound = find_node("VictorySound")
