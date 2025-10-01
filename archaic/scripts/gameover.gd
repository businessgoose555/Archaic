extends CanvasLayer

@onready var score: Label = %score
@onready var highscore: Label = %highscore
@onready var restart: Button = %restart
@onready var quit: Button = %quit

func set_score(n:int):
	score.text = "final score" + str(n)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")



func _on_quit_pressed() -> void:
	pass # Replace with function body.
