extends CharacterBody2D

const SPEED = 400

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _ready() -> void:
	print(
		"Player ",
		name,
		" | local peer = ",
		multiplayer.get_unique_id(),
		" | authority = ",
		get_multiplayer_authority()
	)

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED 

		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()
