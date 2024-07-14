class_name Main extends Node2D;


@onready var proj_parent := $Projectiles;



func spawn_projectile(
	node: Projectile,
	pos: Vector2,
	dir: Vector2,
) -> void:
	proj_parent.add_child(node);
	node.setup(pos, dir);
