class_name PlayerCursor extends Node2D;


@export_group("Juice")
@export var rotation_speed: float = 2.5;
@export var grow_scale: float = 1.25;


func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
	
	rotation += rotation_speed * delta;
