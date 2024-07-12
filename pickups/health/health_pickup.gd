class_name HealthPickup extends Pickup;

## Heals the player.


## The amount of health to give the player on pickup.
@export var amount_to_heal: int = 10;


## Checks if ![method Health.is_health_max] && ![method Health.is_health_zero]
## before attempting to pickup
func can_pickup(ply: Player) -> bool:
	var hp := ply.get_health_component();
	return !hp.is_health_max() && !hp.is_health_zero();


## Heals the player.
func pickup(ply: Player) -> void:
	ply.get_health_component().heal(amount_to_heal);
	queue_free();
