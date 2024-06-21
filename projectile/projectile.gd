class_name Projectile extends CharacterBody2D;

## The base class for all projectiles

## The collision layer every [Projectile] will use.
## Layers: [code]Projectile[/code]
const COLLISION_LAYER: int = 0x20;


## The speed at which the [Projectile] will move.
@export var spd: float = 500.0;
## The direction the [Projectile] will move towards. Also used for rotation.
@export var dir: Vector2 = Vector2.ZERO;
## The amount of damage the [Projectile] will deal to any hitbox it collides with.
@export var dmg: int = 0;
## If true the [Projectile] will collide with enemies, if false it will collide with the player.
@export var friendly: bool = false;

@export_group("Collision Masks")
## The collision mask to use when the [Projectile] is friendly.
## Collides with [code]Enemy Hitbox, World[/code].
@export_flags_2d_physics var friendly_collision_mask: int = 0x11;
## The collision mask to use when the [Projectile] is not friendly.
## Collides with [code]Player Hitbox, World[/code].
@export_flags_2d_physics var hostile_collision_mask: int = 0x5;


## Sets initial values like speed, direction, damage, etc.
func setup(
	speed: float,
	direction: Vector2,
	damage: int,
	friendly: bool
) -> void:
	spd = speed;
	dir = direction.normalized();
	dmg = damage;
	
	if friendly:     collision_mask = friendly_collision_mask;
	else:            collision_mask = hostile_collision_mask;


func _ready() -> void:
	rotation = dir.angle();
	velocity = dir * spd;


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta);
	if collision:
		print_debug("Collided with %s" % collision.get_collider().name);
		queue_free();
