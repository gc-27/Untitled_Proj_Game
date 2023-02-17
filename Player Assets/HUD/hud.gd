extends Node2D

func _ready():
	owner.hit_marker = $HitMarker
	owner.hit_sound = $HitSound
	owner.weapon_sprite = $WeaponSprite

func _process(_delta):
	if owner.technique_current_cd > 0:
		$"Technique Bar/TechniqueCharge".text = str(" ", round(owner.technique_current_cd))
		$"Technique Bar/TechniqueBar".value = (owner.technique_current_cd/ (owner.technique_cd + owner.technique_cd_mod) * -100) + 100
	else:
		$"Technique Bar/TechniqueCharge".text = "0"
	$"Health Bars/HealthBar".value = owner.health
	$"Health Bars/OverhealthBar".value = owner.health - (owner.max_health + owner.max_health_mod)
	$"Health Bars/HealthBar".max_value = (owner.max_health + owner.max_health_mod)
	$"Health Bars/HealthText".text = str(" ", owner.health, "/", (owner.max_health + owner.max_health_mod))
	
	
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = 2 if get_tree().paused else 0
		get_tree().paused = !(get_tree().paused)
		if get_tree().paused:
			$"Health Bars/AnimationPlayer".play("health_bars_menu")
			$"Technique Bar/AnimationPlayer".play("technique_bar_menu")
			$Minimap/AnimationPlayer.play("minimap_menu")
		else:
			$"Health Bars/AnimationPlayer".play_backwards("health_bars_menu")
			$"Technique Bar/AnimationPlayer".play_backwards("technique_bar_menu")
			$Minimap/AnimationPlayer.play_backwards("minimap_menu")


