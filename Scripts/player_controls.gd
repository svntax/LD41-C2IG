extends RigidBody2D

#Walking constants, adjustable
export (int) var WALK_SPEED = 10

#Vehicle constants, adjustable
export (int) var STEERING_SPEED = 8
export (int) var ACCELERATION = 16
export (int) var BRAKE_AMOUNT = 4

#For switching between both movement controls
var VEHICLE_MODE = false
var walkingSprite
var vehicleSprite

func _ready():
    walkingSprite = get_parent().find_node("WalkingSprite")
    vehicleSprite = get_parent().find_node("VehicleSprite")
    self.mode = RigidBody2D.MODE_CHARACTER

#General update loop
func _process(delta):
    if(Input.is_action_just_pressed("RIDE_VEHICLE")):
        if(VEHICLE_MODE):
            #Get out of the vehicle, back to walking
            VEHICLE_MODE = false
            self.mode = RigidBody2D.MODE_CHARACTER
            walkingSprite.show()
            vehicleSprite.hide()
        else:
            #TODO only if near vehicle, for now just a simple toggle
            VEHICLE_MODE = true
            self.mode = RigidBody2D.MODE_RIGID
            vehicleSprite.show()
            walkingSprite.hide()

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
        #Walking controls, uses apply_impulse() with an offset of (0, 0)
        if(Input.is_action_pressed("WALK_LEFT")):
            self.apply_impulse(Vector2(0, 0), Vector2(-WALK_SPEED, 0))
        if(Input.is_action_pressed("WALK_RIGHT")):
            self.apply_impulse(Vector2(0, 0), Vector2(WALK_SPEED, 0))
        if(Input.is_action_pressed("WALK_UP")):
            self.apply_impulse(Vector2(0, 0), Vector2(0, -WALK_SPEED))
        if(Input.is_action_pressed("WALK_DOWN")):
            self.apply_impulse(Vector2(0, 0), Vector2(0, WALK_SPEED))