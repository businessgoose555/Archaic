extends CharacterBody2D

@onready var imp_scene = preload("res://scenes/imp.tscn")
@onready var ghost_scene = preload("res://scenes/ghost.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var imp_minion = imp_scene.instantiate()
		var ghost_minion = ghost_scene.instantiate()
		var x = randf_range(-165.0, 15.0)  # your random X offset
		var y = randf_range(-165.0, 15.0)
		print("Position:")
		print(x)
		print(y)
		imp_minion.global_position = Vector2(x, y)
		ghost_minion.global_position = Vector2(x+1, y+1)
		get_tree().current_scene.add_child.call_deferred(imp_minion)
		get_tree().current_scene.add_child.call_deferred(ghost_minion)
