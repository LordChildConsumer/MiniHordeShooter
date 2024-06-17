class_name Player extends CharacterBody2D;

@export_group("Movement")
@export var move_speed: float = 500.0;
@export var accel: float = 25.0;
@export var decel: float = 20.0;

@export_group("Juice")
@export var cam_weight: float = 0.15;


@onready var cam := $Camera2D as Camera2D;


func _ready() -> void:
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
	
	# Basic Movement
	var input_vec: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	var weight: float = accel if input_vec != Vector2.ZERO else decel;
	velocity = lerp(velocity, input_vec * move_speed, weight * delta);
	move_and_slide();
	
	
	# Camera Panning
	cam.global_position = lerp(global_position, get_global_mouse_position(), cam_weight);
