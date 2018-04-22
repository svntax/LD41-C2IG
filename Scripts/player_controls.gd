extends RigidBody2D

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
var vehicleSprite
var personCamera
var vehicleCamera
var kinematicBody

func _ready():
    walkingSprite = get_parent().find_node("WalkingSprite")
    vehicleSprite = get_parent().find_node("VehicleSprite")
    kinematicBody = get_parent().get_parent().find_node("PlayerKinematicBody")
    personCamera = get_parent().find_node("PersonCamera")
    vehicleCamera = find_node("VehicleCamera")
    #self.mode = RigidBody2D.MODE_KINEMATIC

#General update loop
func _process(delta):
    if(Input.is_action_just_pressed("RIDE_VEHICLE")):
        if(VEHICLE_MODE):
            #Get out of the vehicle, back to walking
            VEHICLE_MODE = false
            #self.mode = RigidBody2D.MODE_KINEMATIC
            walkingSprite.show()
            kinematicBody.set_collision_layer_bit(1, 1)
            personCamera.make_current()
            kinematicBody.position = self.position
        else:
            #Only if near vehicle
            var dist = self.position.distance_to(kinematicBody.position)
            print(dist)
            if(dist < MIN_DIST):
                VEHICLE_MODE = true
                #self.mode = RigidBody2D.MODE_RIGID
                walkingSprite.hide()
                kinematicBody.set_collision_layer_bit(1, 0)
                vehicleCamera.make_current()

#Update loop for handling anything physics related
func _physics_process(delta):
    if(VEHICLE_MODE):
        #Driving controls, uses apply_impulse() at different offsets
        #depending on whether the player is steering left and right
        #or just accelerating or braking
        if(Input.is_action_pressed("STEER_LEFT")):
            self.apply_impulse(Vector2(-8, 0), Vector2(0, STEERING_SPEED))
            self.apply_impulse(Vector2(8, 0), Vector2(0, -STEERING_SPEED))
        if(Input.is_action_pressed("STEER_RIGHT")):
            self.apply_impulse(Vector2(-8, 0), Vector2(0, -STEERING_SPEED))
            self.apply_impulse(Vector2(8, 0), Vector2(0, STEERING_SPEED))
        if(Input.is_action_pressed("DRIVE_FORWARD")):
            var vx = cos(self.rotation) * ACCELERATION
            var vy = sin(self.rotation) * ACCELERATION
            self.apply_impulse(Vector2(0, 0), Vector2(vx, vy))
        if(Input.is_action_pressed("BRAKE")):
            #TODO brake
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
        #kinematicBody.move(Vector2(walkVel.x, 0))
        #kinematicBody.move(Vector2(0, walkVel.y))
        kinematicBody.move_and_slide(walkVel)