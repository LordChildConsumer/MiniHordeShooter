class_name PlayerWeapon extends Marker2D;

## Manages different attacks and tells said attacks when to fire.

@export var current_attack: Attack;


func _ready() -> void:
	if !current_attack:
		push_error("First child of self is not Attack @ '%s'." % get_path());
		return;


func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack_one") && current_attack:
		current_attack.try_attack(
			global_position,
			global_position.direction_to(get_global_mouse_position())
		);

#func _input(event: InputEvent) -> void:
	#if event.is_action("attack_one") && current_attack:
		#current_attack.try_attack(
			#global_position,
			#global_position.direction_to(get_global_mouse_position())
		#);
