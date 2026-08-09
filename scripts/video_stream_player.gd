extends VideoStreamPlayer

func _ready() -> void:
	finished.connect(_on_video_finished)

func _on_video_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
