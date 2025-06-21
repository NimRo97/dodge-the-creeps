extends Node

@export var mob_scene: PackedScene
var score: int = 0

func _ready() -> void:
	# Optionally, you can start a new game here if desired.
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction, with randomness.
	var direction: float = mob_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Assign a random velocity and rotate it to match the direction.
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	mob.linear_velocity = velocity

	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
