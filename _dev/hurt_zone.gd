class_name HurtZone extends Area2D;

## An area that deals damage to any overlapping hitboxes.
## Just used for testing health functionality.


## The amount of damage to deal every [param tick].
@export var damage: float = 10.0;
## The time in seconds between dealing damage.
@export var tick: float = 1.0;


## The [Timer] that causes damage to be dealt every [member tick].
@onready var tick_timer: Timer = Timer.new();

## Keeps track of [Hitbox]es to damage every [member tick]
var hitboxes: Array[Hitbox] = [];


func _ready() -> void:
	tick_timer.wait_time = tick;
	tick_timer.autostart = true;
	tick_timer.timeout.connect(_on_tick_timer_timeout);
	add_child(tick_timer);
	
	area_entered.connect(_on_area_entered);
	area_exited.connect(_on_area_exited);


## Adds [param area] to [member hitboxes] if [param area] is a [Hitbox].
func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		pass;


## Removes [param area] from [member hitboxes] if [member hitboxes] has [param area].
func _on_area_exited(area: Area2D) -> void:
	if area is Hitbox:
		if hitboxes.has(area):
			hitboxes.erase(area);


## Deals damage to [member hitboxes] when [member tick_timer] ends.
func _on_tick_timer_timeout() -> void:
	for hb: Hitbox in hitboxes:
		hb.hurt(damage);
