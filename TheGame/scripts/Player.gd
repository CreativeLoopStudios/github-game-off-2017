extends KinematicBody2D

onready var ray_top = get_node("RayTop")
onready var ray_right = get_node("RayRight")
onready var ray_bottom = get_node("RayBottom")
onready var ray_left = get_node("RayLeft")

onready var sprite_node = get_node("Sprite")

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const MAX_SPEED = 250
const MAX_SPEED_GRABBING = 100
const ACCELERATION = 1000
const DECCELERATION = 1000

var speed = 0
var direction = Vector2()
var velocity = Vector2()

# grab vars
var body_grabbed
var is_grabbing

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	# INPUT
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var space = Input.is_action_pressed("ui_select")
	
	var is_moving = left or right or up or down
	
	if is_moving:
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

	if space:
		var rays_colliding = ray_top.is_colliding() or ray_bottom.is_colliding() or ray_left.is_colliding() or ray_right.is_colliding()
		
		if not body_grabbed:
			if ray_top.is_colliding() and direction == UP:
				body_grabbed = ray_top.get_collider()
			elif ray_bottom.is_colliding() and direction == DOWN:
				body_grabbed = ray_bottom.get_collider()
			elif ray_left.is_colliding() and direction == LEFT:
				body_grabbed = ray_left.get_collider()
			elif ray_right.is_colliding() and direction == RIGHT:
				body_grabbed = ray_right.get_collider()
			else:
				body_grabbed = null

		if body_grabbed and rays_colliding:
			is_grabbing = true
			body_grabbed.push_to(speed, direction)
		else:
			cancel_grab()
	else:
		cancel_grab()

	# MOVEMENT
	speed = clamp(speed, 0, MAX_SPEED)
	
	if is_grabbing:
		speed = clamp(speed, 0, MAX_SPEED_GRABBING)

	velocity = speed * direction.normalized() * delta

	var movement_remainder = move(velocity)
	
	# COLLIDING
	if is_colliding():
		var normal = get_collision_normal()
		velocity = normal.slide(velocity)
		var final_movement = normal.slide(movement_remainder)
		move(final_movement)

	pass

func cancel_grab():
	is_grabbing = false
	if body_grabbed:
		body_grabbed.drop()
		body_grabbed = null