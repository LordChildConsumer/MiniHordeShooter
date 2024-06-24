class_name PlayerCursor extends Node2D;

## Handles all logic related to the player's mouse including
## [b]JUICE[/b] when attacking, and general placement.

@export_group("Juice")
## How fast the cursor rotates when idling.
@export var idle_rotation_speed: float = 1.5;
## The current rotation speed. Value is animated between a given
## [member Attack.cursor_rotation_speed] and [member idle_rotation_speed]
@export var current_rotation_speed: float = idle_rotation_speed;

## A reference to the PlayerWeapon so that this can connect to
## [signal Attack.attack_successful].
@export var player_weapon: PlayerWeapon = null;



## Stores a reference to the current attack.
var current_attack: Attack = null;


func _process(delta: float) -> void:
	global_position = get_global_mouse_position();
	
	# Prevents trying to connect to an attack that no longer exists
	if !current_attack || !is_instance_valid(current_attack):
		current_attack = player_weapon.get_current_attack();
		current_attack.attack_successful.connect(_on_attack_successful);
	
	rotation += current_rotation_speed * delta;


## Juices the cursor when an attack is successful.
## Updates rotation speed and cursor scale.
func _on_attack_successful(speed: float, size: float, duration: float) -> void:
	
	# Rotation
	current_rotation_speed = speed;
	create_tween() \
		.tween_property(self, "current_rotation_speed", idle_rotation_speed, duration) \
		.set_ease(Tween.EASE_OUT);
	
	# Scale
	scale = Vector2(size, size);
	create_tween() \
		.tween_property(self, "scale", Vector2.ONE, duration) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT);
