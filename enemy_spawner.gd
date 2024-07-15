class_name EnemySpawner extends Path2D;

## The Path2D that spawns enemies just outside of view.


## The time in seconds between enemies being spawned.
@export var delay: float = 1.0;

## The array holding the different enemies to spawn.
@export var enemy_scenes: Array[PackedScene];


## The PathFollow2D that controls where exactly the enemy is spawned.
@onready var spawn_point: PathFollow2D = $SpawnPoint as PathFollow2D;

## The parent node all enemies will be instantiated under.
@onready var enemy_parent: Node2D = $EnemyParent as Node2D;


func _ready() -> void:
	_update_size();
	get_viewport().size_changed.connect(_update_size);


## Move Path to stay with the current camera.
func _physics_process(_delta: float) -> void:
	global_position = get_viewport().get_camera_2d().global_position;


## Updates the size of the path to match the viewport.
func _update_size() -> void:
	var vps: Vector2i = get_viewport().size;
	var half_x: float = vps.x * 0.5;
	var half_y: float = vps.y * 0.5;
	
	# Top Left
	curve.set_point_position(0, Vector2(-half_x, -half_y));
	$DebugPoints/TL.position = curve.get_point_position(0);
	
	# Top Right
	curve.set_point_position(1, Vector2(half_x, -half_y));
	$DebugPoints/TR.position = curve.get_point_position(1);
	
	# Bottom Right
	curve.set_point_position(2, Vector2(half_x, half_y));
	$DebugPoints/BR.position = curve.get_point_position(2);
	
	# Bottom Left
	curve.set_point_position(3, Vector2(-half_x, half_y));
	$DebugPoints/BL.position = curve.get_point_position(3);
	
	# Close Loop (Top Left)
	curve.set_point_position(4, Vector2(-half_x, -half_y));


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		spawn_enemy();


## Spawns an enemy at a "random" point along the curve.
func spawn_enemy() -> void:
	# Place the spawn point somewhere along the path.
	spawn_point.progress_ratio = randf();
	
	# Select the enemy and instantiate it.
	var enemy := enemy_scenes[
		randi_range(0, enemy_scenes.size() - 1)
	].instantiate() as Enemy;
	
	# Spawn the enemy
	enemy_parent.add_child(enemy);
	enemy.top_level = true;
	enemy.global_position = spawn_point.global_position;
