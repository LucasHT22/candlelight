extends Area2D

@export var label: Label;


func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		label.text = "These puddles are dangerous!"
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()

func _on_body_exited(body: Node2D) -> void:
	pass
