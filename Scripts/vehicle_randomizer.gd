extends RigidBody2D

var sprite01
var sprite02
var sprite03

#The stats at index i correspond to vehicle i
var steeringStat = [4, 8, 12]
var acceleratingStat = [16, 8, 12]
var brakingStat = [5, 5, 5]
var statIndex = -1

func _ready():
    sprite01 = find_node("VehicleSprite01")
    sprite02 = find_node("VehicleSprite02")
    sprite03 = find_node("VehicleSprite03")
    randomizeVehicle()

func randomizeVehicle():
    randomize()
    var choice = randi() % 3 + 1
    if(choice == 1):
        sprite01.show()
        sprite02.hide()
        sprite03.hide()
    elif(choice == 2):
        sprite01.hide()
        sprite02.show()
        sprite03.hide()
    elif(choice == 3):
        sprite01.hide()
        sprite02.hide()
        sprite03.show()
    statIndex = choice - 1

#Accessor methods for the different stats
func getAccelStat():
    return acceleratingStat[statIndex]

func getSteeringStat():
    return steeringStat[statIndex]

func getBrakingStat():
    return brakingStat[statIndex]
