extends Node

var save_dataarchaic:SaveData

func _ready():
	save_dataarchaic = SaveData.load_or_create()
	
var score: int = 0
