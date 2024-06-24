class_name Player extends CharacterBody2D;

## The Player.

@export_group("Movement")
## The speed the player moves (px/s).
@export var move_speed: float = 500.0;
## Player will reach full speed in [code]1/accel[/code] seconds.
@export var accel: float = 25.0;
## Player will stop moving completely in [code]1/decel[/code] seconds.
@export var decel: float = 20.0;

@export_group("Juice")
## The amount the camera will place itself between the mouse and player.
## [br]1.0 = Cursor
## [br]0.0 = Player
@export var cam_weight: float = 0.15;

## A reference to the player's camera.
@onready var cam := $Camera2D as Camera2D;


func _ready() -> void:
	# Hide the system cursor because I use a custom software cursor for JUICE.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);


# DEBUG: Toggles mouse cursor visibility
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);


func _process(_delta: float) -> void:
	# Mouse Aim
	look_at(get_global_mouse_position());


func _physics_process(delta: float) -> void:
	var movement := get_movement();
	
	velocity = get_new_velocity(
		velocity,
		movement,
		accel if movement != Vector2.ZERO else decel,
		delta
	);
	
	move_and_slide();
	
	
	# Camera Panning
	cam.global_position = lerp(global_position, get_global_mouse_position(), cam_weight);


## Returns the desired movement based on W/A/S/D input.
func get_movement() -> Vector2:
	return Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	).normalized() * move_speed;


## Interpolates the current velocity and the desired velocity gotten from
## [method get_movement].
func get_new_velocity(
	current_velocity: Vector2,
	desired_velocity: Vector2,
	weight: float,
	delta: float,
) -> Vector2:
	return current_velocity.lerp(desired_velocity, weight * delta);
