extends KinematicBody2D

onready var walk = get_node("Walk")
onready var stand = get_node("Stand")
onready var jump = get_node("Jump")

# Member variables
const GRAVITY = 500.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 100

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 0
var jumping = false

var prev_jump_pressed = false

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	maybeWalk(delta)

func maybeWalk(delta):
	var motion = Vector2()
	var speed = 30
	var moSpeed = 3
	var walkLeft = Input.is_action_pressed("move_left")
	var walkRight = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var prev_jump_pressed = false
	
	if walkLeft:
		walkAnim(true)
		motion += Vector2(-moSpeed, 0)
	elif walkRight:
		walkAnim(false)
		motion += Vector2(moSpeed, 0)
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	print(on_air_time < JUMP_MAX_AIRBORNE_TIME)
	print("jump: " + str(jump))
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping):
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	velocity += Vector2(0, GRAVITY)*delta
	motion = motion*speed*delta
	motion = move(motion)
	move(velocity*delta)

# Animate the walk
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
