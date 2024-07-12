class_name Pickup extends Area2D;

## The base class for all pickups.


func _ready() -> void:
	# Set collision layer to be on "Pickups".
	collision_layer = 0x40;
	# Set collision mask to be on "Player Physics".
	collision_mask = 0x2;
	
	# Connect body_entered signal so pickups work
	body_entered.connect(_on_body_entered);


## Checks if [param body] is [Player] and if so calls [method try_pickup].
func _on_body_entered(body: Node2D) -> void:
	print_debug("Collection Zone Body Entered! - %s" % body.name);
	var ply: Player = body as Player;
	if ply:
		if can_pickup(ply):
			pickup(ply);


## Checks if certain criteria is met before collecting.
## Overwritten by subclasses.
func can_pickup(_ply: Player) -> bool:
	return false;


## Runs when [method can_pickup] returns true.
## Overwritten by subclasses.
func pickup(_ply: Player) -> void:
	pass;
