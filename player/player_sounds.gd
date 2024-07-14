extends Node2D

@export_group("Ranges")
@export_subgroup("Attack Pitch Scale")
@export var attack_pitch_min: float = 0.9;
@export var attack_pitch_max: float = 1.1;

@export_group("Nodes")
@export var attack: Attack;


@onready var attack_snd: AudioStreamPlayer = $ShootSND as AudioStreamPlayer;


func _ready() -> void:
	if is_instance_valid(attack):
		attack.attack_successful.connect(_on_attack_successful);


#signal attack_successful(cursor_speed, cursor_size, tween_speed);
func _on_attack_successful(_sp: float, _sz: float, _ts: float) -> void:
	var pitch_offset := randfn(0.5, 0.2);
	
	attack_snd.pitch_scale = attack_pitch_min + \
			(attack_pitch_max - attack_pitch_min) * \
			pitch_offset;
	
	attack_snd.play();
