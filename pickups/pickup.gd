class_name Pickup extends Area2D;

## The base class for all pickups.

## The minimum time in seconds that this node should exist.[br][br]
## Once this time has elapsed, the node will despawn once it is off screen.
@export var lifetime: float = 30.0;

## The [VisibleOnScreenNotifier2D] to check with before freeing node after
## [member lifetime].
@onready var visible_notifier := $Visibility as VisibleOnScreenNotifier2D;


func _ready() -> void:
	# Set collision layer to be on "Pickups".
	collision_layer = 0x40;
	# Set collision mask to be on "Player Physics".
	collision_mask = 0x2;
	
	# Connect body_entered signal so pickups work
	body_entered.connect(_on_body_entered);
	
	# Handle lifetime
	get_tree().create_timer(lifetime).timeout.connect(
		func() -> void:
			# If the node is not screen anymore
			if !visible_notifier.is_on_screen():
				queue_free();
			# If the node is still on screen
			else:
				await visible_notifier.screen_exited;
				queue_free();
	);


## Checks if [param body] is [Player] and if so calls [method try_pickup].
func _on_body_entered(body: Node2D) -> void:
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
