extends Area2D

@export var speed: float = 400.0
var screen_size: Vector2

signal hit

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	var velocity := Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		move(velocity, delta)
	else:
		$AnimatedSprite2D.animation = "walk"
		rotation = 0

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func move(velocity: Vector2, delta: float) -> void:
	$AnimatedSprite2D.animation = "up"
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	rotation = velocity.angle() + PI / 2

func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()
