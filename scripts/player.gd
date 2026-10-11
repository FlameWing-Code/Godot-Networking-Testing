extends CharacterBody2D

const SPEED = 400
@onready var label: Label = $Label

@export var username: String:
	set(value):
		username = value
		label.text = username

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

	# if authority was set to ourselves, change the username
	if is_multiplayer_authority():
		print(NetworkManager.local_username)
		username = NetworkManager.local_username

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED 

		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()
