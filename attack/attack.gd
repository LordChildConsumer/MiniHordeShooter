class_name Attack extends Node2D;

## The base class for all attacks.
## Currently only designed for the player.


## Emitted when a projectile is successfully spawned.
## Currently only used to update the cursor's [b]JUICE[/b].
signal attack_successful(cursor_speed, cursor_size, tween_speed);


@export_group("Stats")
## The amount of time, in seconds, between each attack.
@export var delay: float = 1.0;
## The [Projectile] scene to instance when attacking.
@export var projectile_scene: PackedScene = null;

@export_group("Cursor")
## How fast the cursor spins when a projectile is fired.
@export var cursor_rotation_speed: float = 5.0;
## How much the cursor will grow when a projectile is fired
@export var cursor_grow_scale: float = 1.25;


## The [Timer] used to handle firerate.
@onready var attack_timer: Timer = Timer.new();

## A reference to the [Main] scene.
@onready var main_scene: Main = get_tree().current_scene as Main;


func _ready() -> void:
	# Configure attack_timer
	attack_timer.one_shot = true;
	add_child(attack_timer);
	attack_timer.start(0.01);


## Attempts to spawn a projectile and emits [signal attack_successful]
## when it succeeds.
func try_attack(pos: Vector2, dir: Vector2) -> void:
	# Account for delay
	if attack_timer.time_left > 0.0:
		return;
	
	# Instance projectile_scene and make sure it's actually a projectile.
	var proj: Projectile = projectile_scene.instantiate() as Projectile;
	if !proj:
		push_error("Projectile Scene is not Projectile @ '%s'." % get_path());
		return;
	
	# Spawn projectile
	if !main_scene:
		push_error("Current scene is not main!");
		return;
	main_scene.spawn_projectile(proj, pos, dir);
	
	# Juice the cursor.
	attack_successful.emit(cursor_rotation_speed, cursor_grow_scale, delay);
	
	# Reset timer
	attack_timer.start(delay);
	
