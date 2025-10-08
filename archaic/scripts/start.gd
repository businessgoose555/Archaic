class_name StartScreen
extends CanvasLayer

@onready var score: Label = %score
@onready var highscore: Label = %highscore
@onready var restart: Button = %restart
@onready var quit: Button = %quit

func _ready() -> void:
	var high_score:int = Global.save_dataarchaic.high_score
	highscore.text = "High Score:" + str(high_score)
	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
