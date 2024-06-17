class_name PlayerCursor extends Node2D;


@export_group("Juice")
@export var normal_rotation_speed: float = 1.5;
@export var fire_rotation_speed: float = 5.0;
@export var current_rotation_speed: float = normal_rotation_speed;
@export var grow_scale: float = 1.25;

@export_group("DEBUG")
@export var dbg_firerrate: float = 0.2;
var can_fire: bool = true;



func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
	
	
	if Input.is_action_pressed("attack_one") && can_fire:
		can_fire = false;
		
		# Rotation Speed
		current_rotation_speed = fire_rotation_speed;
		create_tween().tween_property(self, "current_rotation_speed", normal_rotation_speed, dbg_firerrate) \
			.set_ease(Tween.EASE_OUT);
		
		# Scale
		scale = Vector2(grow_scale, grow_scale);
		var scale_tween := create_tween() \
			.tween_property(self, "scale", Vector2.ONE, dbg_firerrate) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT);
		await scale_tween.finished;
		
		can_fire = true;
	
	
	rotation += current_rotation_speed * delta;
