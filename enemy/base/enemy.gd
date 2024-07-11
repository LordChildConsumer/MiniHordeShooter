class_name Enemy extends CharacterBody2D;

## The base class for all enemies. Currently does nothing.

@export_group("Movement")
## The speed this enemy moves at (px/s).
@export var move_speed: float = 150.0;
## Player will reach full speed in [code]1/accel[/code] seconds.
@export var acceleration: float = 20.0;


## Stores a reference to the health component.
## Used for connecting signals.
@onready var health: Health = get_node_or_null("Health") as Health;

## Adds a delay to getting a new target position for performance reasons.
@onready var pathing_timer: Timer = $UpdatePathing as Timer;

## The pivot point of the arrow showing movement direction.
## Used for debugging, will likely not make it to final build.
@onready var dbg_move_dir: Node2D = $MoveDirection as Node2D;

## The enemy's [NavigationAgent2D]. Used to calcuate a safe velocity that
## avoids other enemies.
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D as NavigationAgent2D;

## The position this enemy should be moving towards.
## Updated when [member pathing_timer] times out.
var target_position: Vector2 = Vector2.INF;


func _ready() -> void:
	# Connect health_zero to _on_health_zero if child 'Health' is valid.
	if !health:
		push_warning("No Health Component @ '%s'." % get_path());
	else:
		health.health_zero.connect(_on_health_zero);
	
	# Connect pathing_timer.timeout to update_target_position.
	pathing_timer.timeout.connect(update_target_position);
	
	# Connect velocity_computed to _on_nav_agent_velocity_computed.
	# Used for avoiding other enemies.
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed);
	nav_agent.max_speed = move_speed;


func _physics_process(delta: float) -> void:
	# Using INF as a sort of null here because if that's ever the player's
	# position then weird enemy navigation is the least of my worries.
	if target_position != Vector2.INF:
		var dir := global_position.direction_to(target_position);
		var wish_velocity := dir * move_speed;
		nav_agent.velocity = lerp(
			nav_agent.velocity,
			wish_velocity,
			acceleration * delta
		);
	
	
	# Aim the debug direction visualizer.
	if velocity != Vector2.ZERO:
		dbg_move_dir.look_at(global_position + velocity);




## Gets the enemy's desired [member target_position] when
## [member pathing_timer] reaches zero. [br][br]
## Overwritten by subclasses when relevant.
func update_target_position() -> void:
	target_position = Overseer.player.get_global_position();
	nav_agent.target_position = target_position;
	pathing_timer.start();


## Sets [member velocity] to [param safe_velocity]
## and called [method CharacterBody2D.move_and_slide].
func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity;
	move_and_slide();


## Runs when this enemy's [member health] reaches 0.
func _on_health_zero() -> void:
	queue_free();

