class_name Projectile extends Area2D;

# TODO: Make projectiles an Area2D instead of CharacterBody2D.
#       because move_and_collide() does not collide with areas.

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
## The [RayCast2D] used to check collisions even if the projectile
## skipped over an enemy.
@onready var skip_check: RayCast2D = RayCast2D.new();


func _ready() -> void:
	collision_layer = COLLISION_LAYER;
	
	# Configure lifetime_timer
	lifetime_timer.wait_time = max_lifetime;
	lifetime_timer.autostart = true;
	lifetime_timer.one_shot = true;
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout);
	add_child(lifetime_timer);
	
	# Add skip_check to scene.
	add_child(skip_check);


## Sets initial values like speed, direction, damage, etc.
## CALLED AFTER [method _ready].
func setup(
	spawn_position: Vector2,
	direction: Vector2,
	# TODO: Remove damage, is_friendly, and speed from this.
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
	
	# Configure skip_check
	skip_check.collision_mask = collision_mask;
	skip_check.collide_with_areas = true;
	
	# Set velocity and face direction
	rotation = dir.angle();


func _physics_process(delta: float) -> void:
	# Move the projectile.
	var next_pos := get_next_global_position(dir * spd * delta);
	global_position = next_pos;
	
	# Check for hitboxes.
	for area: Area2D in get_overlapping_areas():
		if area is Hitbox:
			(area as Hitbox).hurt(dmg);
			print_debug("Hurt Hitbox for %s" % dmg);
			queue_free();
	
	# Check for bodies.
	if get_overlapping_bodies().size() > 0:
		print_debug("Hit body!");
		queue_free();


## Gets the next position of the projectile based on the projectile's velocity.
## If skip_check is colliding the collision point is returned instead.
func get_next_global_position(velocity: Vector2) -> Vector2:
	skip_check.target_position = velocity;
	
	if skip_check.is_colliding():
		# FIXME: Causes unintended behavior when colliding with non-hitbox area
		return skip_check.get_collision_point();
	
	else:
		return global_position + velocity;


## Frees the projectile when [member lifetime_timer] has reached 0.
func _on_lifetime_timer_timeout() -> void:
	queue_free();
