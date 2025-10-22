class_name StartScreen
extends CanvasLayer

@onready var score: Label = %score
@onready var highscore: Label = %highscore
@onready var restart: Button = %restart
@onready var quit: Button = %quit
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	var high_score:int = Global.save_dataarchaic.high_score
	highscore.text = "High Score:" + str(high_score)

func _on_start_pressed() -> void:
	var random_map = rng.randi_range(2, 2)
	print (random_map)
	if random_map == 1:
		get_tree().change_scene_to_file("res://scenes/world_1_1.tscn")
	elif random_map == 2:
		get_tree().change_scene_to_file("res://scenes/map 1.2.tscn")
	elif random_map == 3:
		get_tree().change_scene_to_file("res://scenes/map 1.3 .tscn")
	elif random_map == 4:
		get_tree().change_scene_to_file("res://scenes/map 1.4.tscn")
	elif random_map == 5:
		get_tree().change_scene_to_file("res://scenes/map 1.5 .tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
