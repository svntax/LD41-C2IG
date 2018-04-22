extends KinematicBody2D

#Walking constants, adjustable
export (int) var WALK_SPEED = 64

var walkVel = Vector2()

#Vehicle constants, adjustable
export (int) var STEERING_SPEED = 8
export (int) var ACCELERATION = 16
export (int) var BRAKE_AMOUNT = 4

#For switching between both movement controls
var VEHICLE_MODE = false
var MIN_DIST = 48
var walkingSprite
var personCamera
var kinematicBody
var vehicleBody

func _ready():
    walkingSprite = get_parent().find_node("WalkingSprite")
    kinematicBody = self
    personCamera = find_node("PersonCamera")
    vehicleBody = null

#General update loop
func _process(delta):
    if(Input.is_action_just_pressed("RIDE_VEHICLE")):
        if(VEHICLE_MODE):
            #Get out of the vehicle, back to walking
            VEHICLE_MODE = false
            walkingSprite.show()
            kinematicBody.set_collision_layer_bit(0, 1)
            personCamera.make_current()
            kinematicBody.global_position = vehicleBody.global_position
        else:
            #Only if near vehicle
            var vehicleList = get_tree().get_nodes_in_group("vehicles")
            for v in vehicleList:
                #TODO might have to adjust if multiple vehicles nearby
                var dist = self.global_position.distance_to(v.global_position)
                if(dist < MIN_DIST):
                    VEHICLE_MODE = true
                    walkingSprite.hide()
                    kinematicBody.set_collision_layer_bit(0, 0)
                    vehicleBody = v
                    vehicleBody.find_node("VehicleCamera").make_current()
                    #Change the current stats to be used for vehicle controls
                    STEERING_SPEED = vehicleBody.getSteeringStat()
                    ACCELERATION = vehicleBody.getAccelStat()
                    BRAKE_AMOUNT = vehicleBody.getBrakingStat()
                    break

#Update loop for handling anything physics related
func _physics_process(delta):
    if(VEHICLE_MODE):
        #Make sure the invisible player object follows the vehicle
        kinematicBody.global_position = vehicleBody.global_position
        #Driving controls, uses apply_impulse() at different offsets
        #depending on whether the player is steering left and right
        #or just accelerating or braking
        if(Input.is_action_pressed("STEER_LEFT")):
            vehicleBody.apply_impulse(Vector2(-8, 0), Vector2(0, STEERING_SPEED))
            vehicleBody.apply_impulse(Vector2(8, 0), Vector2(0, -STEERING_SPEED))
        if(Input.is_action_pressed("STEER_RIGHT")):
            vehicleBody.apply_impulse(Vector2(-8, 0), Vector2(0, -STEERING_SPEED))
            vehicleBody.apply_impulse(Vector2(8, 0), Vector2(0, STEERING_SPEED))
        if(Input.is_action_pressed("DRIVE_FORWARD")):
            var vx = cos(vehicleBody.rotation) * ACCELERATION
            var vy = sin(vehicleBody.rotation) * ACCELERATION
            vehicleBody.apply_impulse(Vector2(0, 0), Vector2(vx, vy))
        if(Input.is_action_pressed("BRAKE")):
            var vx = cos(vehicleBody.rotation) * BRAKE_AMOUNT
            var vy = sin(vehicleBody.rotation) * BRAKE_AMOUNT
            vehicleBody.apply_impulse(Vector2(0, 0), Vector2(-vx, -vy))
            pass
    else:
        walkVel.x = 0
        walkVel.y = 0
        #Walking controls, uses apply_impulse() with an offset of (0, 0)
        if(Input.is_action_pressed("WALK_LEFT")):
            walkVel.x = -WALK_SPEED
        if(Input.is_action_pressed("WALK_RIGHT")):
            walkVel.x = WALK_SPEED
        if(Input.is_action_pressed("WALK_UP")):
            walkVel.y = -WALK_SPEED
        if(Input.is_action_pressed("WALK_DOWN")):
            walkVel.y = WALK_SPEED
        kinematicBody.move_and_slide(walkVel)