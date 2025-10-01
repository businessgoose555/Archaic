extends CanvasLayer

@onready var score: Label = %score
@onready var highscore: Label = %highscore
@onready var restart: Button = %restart
@onready var quit: Button = %quit

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
