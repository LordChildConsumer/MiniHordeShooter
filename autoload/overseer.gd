extends Node

## Stores various bits of data that will be relevant to several
## entities during gameplay. Ex: the position of the player.


## Stores info related to the player.
class player:
	## Stores a reference to the player node.
	static var node: Player = null;
	
	## Gets the player's global position. Returns [param null] if [member node]
	## is null or invalid instance.
	static func get_global_position() -> Vector2:
		if !is_instance_valid(node):
			return Vector2.INF;
		
		return node.global_position;
