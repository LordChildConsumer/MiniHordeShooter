extends CanvasLayer



@export var camera: Camera2D;
@onready var shader := ($Dots as ColorRect).material as ShaderMaterial;

func _physics_process(_delta: float) -> void:
	shader.set_shader_parameter("offset", camera.get_screen_center_position());
