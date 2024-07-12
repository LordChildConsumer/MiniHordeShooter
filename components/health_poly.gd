class_name HealthPolygon extends Polygon2D;

## Updates the shader attached to this polygon to display the current health.


## The [Health] component to receive signal(s) from.
@export var health_component: Health;

@export_group("Tween")
## The time it takes to [Tween] the health bar to actual value.
@export var tween_duration: float = 0.1;
## The easing of the [Tween].
@export var tween_ease: Tween.EaseType = Tween.EASE_OUT;
## The transition type of the [Tween].
@export var tween_trans: Tween.TransitionType = Tween.TRANS_QUINT;

## Stores a reference to the polygon's [ShaderMaterial] so [param pct] can be updated.
var shader: ShaderMaterial;

## Stores the currently active tween.
## Used to easily kill it and create a new one.
var current_tween: Tween = null;


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
	
	# Kill and remove the current_tween.
	if current_tween != null && current_tween.is_valid():
		current_tween.kill();
		current_tween = null;
	
	# Create new tween.
	current_tween = create_tween();
	current_tween.tween_property(
		shader,
		"shader_parameter/pct",
		pct,
		tween_duration
	).set_trans(tween_trans).set_ease(tween_ease);
