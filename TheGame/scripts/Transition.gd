extends CanvasLayer

var next_scene_path

func fade_to(path):
	next_scene_path = path
	get_node("Anim").play("Fade")

func change_scene():
	if next_scene_path != null:
		get_tree().change_scene(next_scene_path)