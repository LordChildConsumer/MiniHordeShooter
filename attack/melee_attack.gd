class_name MeleeAttack extends Area2D;

## Deals damage to hitboxes in range every [member delay] seconds.


## Decides which collision mask to use for detecting areas.
@export var is_friendly: bool = false;

@export_group("Stats")
## The damage dealt when attacking.
@export var damage: int = 5;
## The amount of time, in seconds, between each attack.
@export var delay: float = 1.0;


@export_group("Collision Masks")
## The collision mask to find overlapping areas.
## Collides with [code]Enemy Hitbox[/code].
@export_flags_2d_physics var friendly_collision_mask: int = 0x10;
## The collision mask to find overlapping areas.
## Collides with [code]Player Hitbox[/code].
@export_flags_2d_physics var hostile_collision_mask: int = 0x4;


## The [Timer] used to handle firerate/delay.
@onready var attack_timer: Timer = Timer.new();

## A list of overlapping hitboxes to deal damage to
## every [member delay] seconds.
var target_hitboxes: Array[Hitbox] = [];


func _ready() -> void:
	# Configure collision mask
	collision_mask = friendly_collision_mask if is_friendly \
				else hostile_collision_mask;
	
	# Configure attack_timer
	add_child(attack_timer);
	attack_timer.wait_time = delay;
	attack_timer.one_shot = true;
	attack_timer.timeout.connect(hurt_hitboxes);
	
	# Connect signal to listen for overlapping bodies.
	area_entered.connect(_on_area_entered);
	area_exited.connect(_on_area_exited);


## If the given area is a hitbox and not already part of
## [member target_hitboxes] then add it.
func _on_area_entered(area: Area2D) -> void:
	var hb: Hitbox = area as Hitbox;
	if hb && !target_hitboxes.has(hb):
		target_hitboxes.push_back(hb);
		
		if attack_timer.is_stopped():
			hurt_hitboxes();


## If the given area is a hitbox and part of
## [member target_hitboxes] then remove it.
func _on_area_exited(area: Area2D) -> void:
	var hb: Hitbox = area as Hitbox;
	if hb && target_hitboxes.has(hb):
		target_hitboxes.erase(hb);
		
		if target_hitboxes.is_empty():
			attack_timer.stop();


## Loops through [member target_hitboxes] and deals damage to each hitbox.
func hurt_hitboxes() -> void:
	for hb: Hitbox in target_hitboxes:
		hb.hurt(damage);
	
	attack_timer.start(delay);
