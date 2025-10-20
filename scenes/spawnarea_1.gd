extends CharacterBody2D

@onready var imp_scene = preload("res://scenes/imp.tscn")
@onready var ghost_scene = preload("res://scenes/ghost.tscn")
@onready var cshape: CollisionShape2D = $Area2D/CollisionShape2D
var spawn_corners : Array[Vector2] 


func _ready():
# If another script assigns the shape in its _ready(), a single frame wait helps.
	if cshape.shape == null:
		await get_tree().process_frame

	var corners := get_rect_corners_global(cshape)
	if corners.is_empty():
		push_error("No RectangleShape2D assigned at $Area2D/CollisionShape2D.")
		return

	for i in corners.size():
		print("Corner %d: %s" % [i, corners[i]])

func get_rect_corners_global(cs: CollisionShape2D) -> Array[Vector2]:
	if cs == null: return []
	var rect := cs.shape as RectangleShape2D
	if rect == null: return []

	var e : Vector2 = rect.extents
	spawn_corners.append_array([
		Vector2(-e.x, -e.y),  # TL
		Vector2( e.x,  e.y),  # BR
	])

	var xf : Transform2D = cs.global_transform
	for i in spawn_corners.size():
		spawn_corners[i] = xf * spawn_corners[i]
	return spawn_corners

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var imp_minion = imp_scene.instantiate()
		var ghost_minion = ghost_scene.instantiate()
		var offset = 50
		var x = randf_range(spawn_corners[0][0]+offset, spawn_corners[1][0]-offset)
		var y = randf_range(spawn_corners[0][1]+offset, spawn_corners[1][1]-offset)
		imp_minion.global_position = Vector2(x, y)
		ghost_minion.global_position = Vector2(x+1, y+1)
		get_tree().current_scene.add_child.call_deferred(imp_minion)
		get_tree().current_scene.add_child.call_deferred(ghost_minion)
		self.queue_free()
