class_name InventoryItem  extends RefCounted

var item_data: ItemData
var quantity: int = 0

func _init(p_item_data: ItemData, p_quantity: int) -> void:
	item_data = p_item_data
	quantity = p_quantity
	
