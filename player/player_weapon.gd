class_name PlayerWeapon extends Marker2D;

## Manages different attacks and tells said attacks when to fire.

# TODO: Add a signal for weapon switching..?

## Stores a reference to the current attack.
var attack: Attack = null;

func _ready() -> void:
	for c: Node in get_children():
		if c is Attack:
			attack = c as Attack;
		else:
			push_warning("Child %s of Player Weapon is not Attack!");


func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack_one") && attack:
		attack.try_attack(
			global_position,
			global_position.direction_to(get_global_mouse_position())
		);


## Returns a reference to the current attack.
## Currently only used to listen for [signal Attack.attack_successful]
func get_current_attack() -> Attack:
	return attack;
