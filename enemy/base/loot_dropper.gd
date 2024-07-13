class_name LootDropper extends Node2D;

# TODO: Make this a resource based system of some sorts idk my brain is fried.


## 5%.
@export var legendary_drops: Array[PackedScene];
## 15%.
@export var rare_drops: Array[PackedScene];
## 30%
@export var common_drops: Array[PackedScene];


func try_drop() -> void:
	var rand := randf();
	
	# Legendary
	if   rand <= 0.05:   _drop(legendary_drops);
	# Rare
	elif rand <= 0.15:   _drop(rare_drops);
	# Common
	elif rand <= 0.30:   _drop(common_drops);


func _drop(list: Array[PackedScene]) -> void:
	# TODO: Maybe drop rarity down one if the list is empty?
	if list.size() > 0:
		var i := randi_range(0, list.size() - 1);
		var item := list[i].instantiate();
		get_tree().current_scene.add_child(item);
		item.global_position = global_position;
