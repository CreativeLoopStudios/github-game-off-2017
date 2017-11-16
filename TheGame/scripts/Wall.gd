extends StaticBody2D

func _ready():
	set_process(true)
	pass

func _process(delta):
	set_z(get_pos().y)
	pass
