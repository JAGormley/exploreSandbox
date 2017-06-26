extends KinematicBody2D

onready var walk = get_node("Walk")
onready var stand = get_node("Stand")
onready var jump = get_node("Jump")

# Member variables
const GRAVITY = 500.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
#const FLOOR_ANGLE_TOLERANCE = 40
#const WALK_FORCE = 600
#const WALK_MIN_SPEED = 10
#const WALK_MAX_SPEED = 200
#const STOP_FORCE = 1300
const JUMP_SPEED = 200
const GEN_SPEED = 1
const WALK_SPEED = 100
#const JUMP_MAX_AIRBORNE_TIME = 100

var velocity = Vector2()
var on_air_time = 0
var jumping = false
var onGround = false

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	maybeMove(delta)









func maybeMove(delta):
	var GEN_SPEED = 30
	var walkLeft = Input.is_action_pressed("move_left")
	var walkRight = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	onGround = test_move(Vector2(0,1))
	
	if walkLeft:
		walkAnim(true)
		velocity.x += -WALK_SPEED
	elif walkRight:
		walkAnim(false)
		velocity.x += WALK_SPEED
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	velocity.y += GRAVITY*delta
	velocity.x = velocity.x*GEN_SPEED*delta
	var motion_remainder = move(velocity*delta)
	print(motion_remainder)
#	motion_remainder += move(Vector2(0, velocity.y*delta))
	
	#TODO: make this check for the ground instead of general collision
	if is_colliding():
		var normal = get_collision_normal()
		var slope_angle = rad2deg(acos(normal.dot(Vector2(0,-1))))
		if slope_angle > 0:
			revert_motion()
#			revert_motion()
			
		
		velocity.y = 0
		if (jump and not jumping):
			velocity.y = -JUMP_SPEED
			jumping = true
		var final_movement = normal.slide(motion_remainder)
		final_movement = move(final_movement)












# sfh = bool: set flip horizontal
func walkAnim(sfh):
	stand.hide()
	walk.show()
	walk.play()
	walk.set_flip_h(sfh)
	stand.set_flip_h(sfh)
	
func _input(event):
	if (event.is_action_released("move_left") || event.is_action_released("move_right")):
		walk.stop()
		walk.set_frame(0)
		walk.hide()
		stand.show()
