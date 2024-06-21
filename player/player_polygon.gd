class_name PlayerPolygon extends Polygon2D;

## Updates any shader(s) on the player's polygon. Currently only use for health.


## The [Health] component to receive signal(s) from.
@export var health_component: Health;

## Stores a reference to the polygon's [ShaderMaterial] so [param pct] can be updated.
var shader: ShaderMaterial;


func _ready() -> void:
	
	# Gets a reference to the 'pct' uniform in the health shader.
	var m: ShaderMaterial = material as ShaderMaterial;
	if m: shader = m;
	
	# Push an error if there is no health component given.
	if !health_component:
		push_error("No Health Component given @ '%s'." % get_path);
		return;
	
	health_component.health_changed.connect(_on_health_component_health_changed);


## Updates the [param pct] of the health shader.
func _on_health_component_health_changed(new_health: int) -> void:
	# Maps current health between 0.0 and 1.0 since that's what 'pct' expects.
	var pct := inverse_lerp(0.0, health_component.max_health, new_health);
	shader.set_shader_parameter("pct", pct);
