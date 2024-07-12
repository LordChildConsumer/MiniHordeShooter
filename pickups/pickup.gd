class_name Pickup extends Area2D;

## If the player remains completely still, the pickup will take
## [code]1.0 / chase_speed[/code] seconds to reach them.
@export var chase_speed: float = 5.0;


## The area used to detect if the player is within range.
@onready var collection_zone: Area2D = $CollectionZone;

## Used for "chasing" the player before picking up.
## If value is [b]NOT[/b] null, pickup will chase player.
var player_node: Player;


func _ready() -> void:
	# Set collision layer to be on "Pickups".
	collision_layer = 0x40;
	# Set collision mask to be on "Player Physics".
	collision_mask = 0x2;
	
	# Connect collect_zone body entered to detect when the player is in range.
	collection_zone.body_entered.connect(_on_collection_zone_body_entered);
	


## Checks if [param body] is [Player] and if so calls [method try_pickup].
func _on_collection_zone_body_entered(body: Node2D) -> void:
	print_debug("Collection Zone Body Entered! - %s" % body.name);
	var ply: Player = body as Player;
	if ply:
		if can_pickup(ply):
			# Connect body_entered to function that actually collects pickup.
			body_entered.connect(on_pickup);
			collection_zone.queue_free();
			
			create_tween().tween_property(
				self,
				"global_position",
				ply.global_position,
				0.2
			).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN);


## Checks if certain criteria is met before collecting.
## Overwritten by subclasses.
func can_pickup(_ply: Player) -> bool:
	return false;


## Runs when [method can_pickup] returns true.
## Overwritten by subclasses.
func on_pickup(_body: Node2D) -> void:
	pass;


#func _physics_process(delta: float) -> void:
	#if !is_instance_valid(player_node):
		#return;
	#
	## Chase the player
	#
