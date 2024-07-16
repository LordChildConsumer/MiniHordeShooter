class_name EnemySounds extends Node2D;

## Just an interface to keep enemy.gd a little cleaner.


@export_group("Hurt")
@export var hurt_pitch_min: float = 0.9;
@export var hurt_pitch_max: float = 1.1;

@export_group("Death")
@export var death_pitch_pin: float = 0.9;
@export var death_pitch_max: float = 1.1;


## The [AudioStreamPlayer2D] with the attack sound.
@onready var attack := $Attack as AudioStreamPlayer2D;
## The [AudioStreamPlayer2D] with the hurt sound.
@onready var hurt := $Hurt as AudioStreamPlayer2D;
## The [AudioStreamPlayer2D] with the death sound.
@onready var death := $Death as AudioStreamPlayer2D;




func play_attack() -> void:
	pass;


func play_hurt() -> void:
	hurt.pitch_scale = get_pitch_scale(hurt_pitch_min, hurt_pitch_max);
	hurt.play();


func play_death() -> void:
	death.pitch_scale = get_pitch_scale(death_pitch_pin, death_pitch_max);
	death.play();



## Returns [code]min_scale + (max_scale - min_scale) * randfn(0.5, 0.2)[/code].
func get_pitch_scale(min_scale: float, max_scale: float) -> float:
	var offset := randfn(0.5, 0.2);
	return min_scale + (max_scale - min_scale) * offset;
