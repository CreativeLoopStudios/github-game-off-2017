extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 1000

var speed = 0
var direction = Vector2()
var velocity = Vector2()

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if speed > 0:
		# MOVEMENT
		speed = clamp(speed, 0, MAX_SPEED)
	
		velocity = speed * direction.normalized() * delta
		
		var movement_remainder = move(velocity)
		# COLLIDING
		if is_colliding():
			var normal = get_collision_normal()
			velocity = normal.slide(velocity)
			var final_movement = normal.slide(movement_remainder)
			move(final_movement)

func push_to(speed, direction):
	print("push")
	self.speed = speed
	self.direction = direction
	
func drop():
	self.speed = 0
	self.direction = Vector2()
	