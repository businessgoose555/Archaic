class_name GameOver extends CanvasLayer

@onready var score: Label = %score
@onready var highscore: Label = %highscore
@onready var restart: Button = %restart
@onready var quit: Button = %quit

func set_score(n:int):
	score.text = "Final Score: " + str(n)
	if n > Global.save_dataarchaic.high_score:
		highscore.visible = true
		Global.save_dataarchaic.high_score = n
		Global.save_dataarchaic.save()
	else:
		highscore.visible = false

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
