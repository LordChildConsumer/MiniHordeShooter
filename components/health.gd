class_name Health extends Node;

## Stores an entity's health, typically referenced by a Hitbox Component

signal health_changed(new_health);
signal health_zero;


## The maximum amount of health the entity may have.
@export var max_health: int = 100;
## The amount of health the entity currently has.
@export var health: int = 100 : set = set_health, get = get_health;


# ---- Health Set/Get ---- #
func set_health(value: int) -> void:
	health = value;
	health_changed.emit(health);
	if health <= 0: health_zero.emit();

func get_health() -> int:
	return health;


# ---- Mutation Functions ---- #
## Subtracts the given value from the current health. End result will be no less than 0.
func hurt(value: int) -> void:
	health = max(health - value, 0);
	print_debug("Hurt for %s. Health left = %s" % [value, health]);

## Adds the given value to the current health. End result will be no greater than [member max_health]
func heal(value: int) -> void:
	health = min(health + value, max_health);


# ---- Utility Functions ---- #
## Returns true if [code]health >= max_health[/code]. Otherwise false.
func is_health_max() -> bool:
	return health >= max_health;

## Returns true if [code]health <= 0[/code]. Otherwise false.
func is_health_zero() -> bool:
	return health <= 0;
