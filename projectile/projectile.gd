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
## The amount of time in seconds this [Projectile] will exist before freeing itself.
@export var max_lifetime: float = 15.0;

@export_group("Collision Masks")
## The collision mask to use when the [Projectile] is friendly.
## Collides with [code]Enemy Hitbox, World[/code].
@export_flags_2d_physics var friendly_collision_mask: int = 0x11;
## The collision mask to use when the [Projectile] is not friendly.
## Collides with [code]Player Hitbox, World[/code].
@export_flags_2d_physics var hostile_collision_mask: int = 0x5;

## When this timer reaches 0 the projectile will automatically despawn.
@onready var lifetime_timer: Timer = Timer.new();


## Sets initial values like speed, direction, damage, etc.
func setup(
	spawn_position: Vector2,
	direction: Vector2,
	damage: int = dmg,
	is_friendly: bool = friendly,
	speed: float = spd
) -> void:
	# Set basic values
	global_position = spawn_position;
	spd = speed;
	dir = direction.normalized();
	dmg = damage;
	
	# Configure collision mask
	if is_friendly:     collision_mask = friendly_collision_mask;
	else:               collision_mask = hostile_collision_mask;
	
	# Set velocity and face direction
	rotation = dir.angle();
	velocity = dir * spd;


func _ready() -> void:
	collision_layer = COLLISION_LAYER;
	
	# Configure lifetime_timer
	lifetime_timer.wait_time = max_lifetime;
	lifetime_timer.autostart = true;
	lifetime_timer.one_shot = true;
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout);
	add_child(lifetime_timer);


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta);
	if collision:
		# TODO: Deal damage to hitboxes.
		print_debug("Collided with %s" % collision.get_collider().name);
		queue_free();


## Frees the projectile when [member lifetime_timer] has reached 0.
func _on_lifetime_timer_timeout() -> void:
	queue_free();
