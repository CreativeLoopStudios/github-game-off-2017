extends KinematicBody2D

onready var sprite_node = get_node("Sprite")

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const MAX_SPEED = 250
const ACCELERATION = 1000
const DECCELERATION = 1000

var speed = 0
var direction = Vector2()
var velocity = Vector2()

func _ready():
	set_process(true)
	
func _process(delta):
	# INPUT
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var space = Input.is_action_pressed("ui_select")
	
	var is_moving = left or right or up or down
	
	if is_moving and not space:
		direction = Vector2()
		if left:
			direction += LEFT
			sprite_node.set_flip_h(true)
		elif right:
			direction += RIGHT
			sprite_node.set_flip_h(false)
		if up:
			direction += UP
		elif down:
			direction += DOWN

		speed += ACCELERATION * delta
	else:
		if speed > 0:
			speed -= DECCELERATION * delta

	# MOVEMENT
	speed = clamp(speed, 0, MAX_SPEED)

	velocity = speed * direction.normalized() * delta
	
	var movement_remainder = move(velocity)
	
	# COLLIDING
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		move(final_movement)
		
		print(get_collider())
		
		