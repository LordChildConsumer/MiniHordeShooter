class_name Hitbox extends Area2D;

## Receives damage and passes it along to a linked Health Component


## Health Component to modify.
@export var health: Health;


func _ready() -> void:
	if health == null:
		push_error("Hitbox has no Health @ '%s'" % get_path());
		queue_free();
		return;


## Deals damage to linked [Health]
func hurt(value: int) -> void:
	health.hurt(value);


## Returns a reference to the linked [Health]
func get_health_component() -> Health:
	return health;
