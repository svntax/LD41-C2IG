extends KinematicBody2D

#Walking constants, adjustable
export (int) var WALK_SPEED = 96

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

var numEnemies
var health
var gameOverUI

var animationPlayer

func _ready():
    #walkingSprite = get_parent().find_node("WalkingSprite")
    walkingSprite = find_node("AnimatedSprite")
    kinematicBody = self
    personCamera = find_node("PersonCamera")
    vehicleBody = null
    numEnemies = 0
    health = 5
    animationPlayer = find_node("AnimationPlayer")
    gameOverUI = get_parent().get_parent().find_node("GameOverUI")

#General update loop
func _process(delta):
    if(Input.is_action_just_pressed("RIDE_VEHICLE")):
        if(VEHICLE_MODE):
            #Get out of the vehicle, back to walking
            VEHICLE_MODE = false
            if(SoundHandler.drivingSound.playing):
                SoundHandler.drivingSound.stop()
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
                    if(SoundHandler.walkingSound.playing):
                        SoundHandler.walkingSound.stop()
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
        var isDriving = false
        if(Input.is_action_pressed("STEER_LEFT")):
            isDriving = true
            vehicleBody.apply_impulse(Vector2(-8, 0), Vector2(0, STEERING_SPEED))
            vehicleBody.apply_impulse(Vector2(8, 0), Vector2(0, -STEERING_SPEED))
        if(Input.is_action_pressed("STEER_RIGHT")):
            isDriving = true
            vehicleBody.apply_impulse(Vector2(-8, 0), Vector2(0, -STEERING_SPEED))
            vehicleBody.apply_impulse(Vector2(8, 0), Vector2(0, STEERING_SPEED))
        if(Input.is_action_pressed("DRIVE_FORWARD")):
            isDriving = true
            var vx = cos(vehicleBody.rotation) * ACCELERATION
            var vy = sin(vehicleBody.rotation) * ACCELERATION
            vehicleBody.apply_impulse(Vector2(0, 0), Vector2(vx, vy))
        if(Input.is_action_pressed("BRAKE")):
            isDriving = true
            var vx = cos(vehicleBody.rotation) * BRAKE_AMOUNT
            var vy = sin(vehicleBody.rotation) * BRAKE_AMOUNT
            vehicleBody.apply_impulse(Vector2(0, 0), Vector2(-vx, -vy))
        if(isDriving):
            if(not SoundHandler.drivingSound.playing):
                SoundHandler.drivingSound.play()
            vehicleBody.find_node("Particles2D").emitting = true
        else:
            if(SoundHandler.drivingSound.playing):
                SoundHandler.drivingSound.stop()
            vehicleBody.find_node("Particles2D").emitting = false
    else:
        walkVel.x = 0
        walkVel.y = 0
        #Walking controls, uses apply_impulse() with an offset of (0, 0)
        if(Input.is_action_pressed("WALK_LEFT")):
            walkVel.x = -WALK_SPEED
            self.rotation_degrees = 90
        if(Input.is_action_pressed("WALK_RIGHT")):
            walkVel.x = WALK_SPEED
            self.rotation_degrees = 270
        if(Input.is_action_pressed("WALK_UP")):
            walkVel.y = -WALK_SPEED
            self.rotation_degrees = 180
        if(Input.is_action_pressed("WALK_DOWN")):
            walkVel.y = WALK_SPEED
            self.rotation_degrees = 0
        if(walkVel.x != 0 or walkVel.y != 0):
            if(not animationPlayer.is_playing()):
                animationPlayer.play("walkAnim", -1, 1.3)
            if(not SoundHandler.walkingSound.playing):
                SoundHandler.walkingSound.play()
        else:
            if(animationPlayer.is_playing()):
                animationPlayer.stop(true)
            if(SoundHandler.walkingSound.playing):
                SoundHandler.walkingSound.stop()
                
        kinematicBody.move_and_slide(walkVel)

func _on_PlayerHitbox_body_entered(body):
    if(body.is_in_group("enemies")):
        if(numEnemies == 0):
            find_node("DamageTimer").start()
        numEnemies += 1
        damagePlayer()
        #print("Num enemies: %d" % numEnemies)

func _on_PlayerHitbox_body_exited(body):
    if(body.is_in_group("enemies")):
        numEnemies -= 1
        if(numEnemies == 0):
            find_node("DamageTimer").stop()
        #print("Num enemies: %d" % numEnemies)

func _on_DamageTimer_timeout():
    damagePlayer()
    
func damagePlayer():
    health -= 1
    SoundHandler.hurtSound.play()
    var damageEffect = get_parent().get_parent().find_node("ColorRect")
    damageEffect.toggleEffect()
    if(health <= 0):
        find_node("DamageTimer").stop()
        gameOverUI.showGameOverUI()
