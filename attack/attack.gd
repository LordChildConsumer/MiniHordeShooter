class_name Attack extends Node2D;

## The base class for all attacks.


## Emitted when a projectile is successfully spawned.
## Used mainly to update the cursor's juice.
signal attack_successful;


## The amount of time, in seconds, between each attack.
@export var delay: float = 1.0;
## The [Projectile] scene to instance when attacking.
@export var projectile_scene: PackedScene = null;


## The [Timer] used to handle firerate.
@onready var attack_timer: Timer = Timer.new();


func _ready() -> void:
	# Configure attack_timer
	attack_timer.autostart = true;
	attack_timer.one_shot = true;
	add_child(attack_timer);


func try_attack(pos: Vector2, dir: Vector2) -> void:
	# Account for delay
	if attack_timer.time_left > 0.0:
		return;
	
	# Instance projectile_scene and make sure it's actually a projectile.
	var proj: Projectile = projectile_scene.instantiate() as Projectile;
	if !proj:
		push_error("Projectile Scene is not Projectile @ '%s'." % get_path());
		return;
	
	# TODO: Make dedicated projectile parent so this is redundant.
	proj.top_level = true;
	add_child(proj);
	
	# Spawn the projectile.
	proj.setup(pos, dir);
	
	# Juice the cursor.
	attack_successful.emit();
	
	# Reset timer
	attack_timer.start(delay);
	
