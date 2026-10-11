extends Node2D

@export var player: PackedScene
const BALL = preload("res://scenes/ball.tscn")
var can_create_ball = false
	
func create_player(id: int) -> void:
	var instance = player.instantiate()
	instance.name = str(id)
	
	$Players.add_child(instance)
	
#only called when a peer connects on the server side
#only connected to event when hosting
func _on_peer_connected(id: int) -> void:
	create_player(id)
	
func _on_poopy_buttons_host_pressed() -> void:
	can_create_ball = true
	NetworkManager.create_server()
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	create_player(multiplayer.get_unique_id())

func _on_poopy_buttons_join_pressed() -> void:
	can_create_ball = true
	NetworkManager.create_client()
	
func _input(event: InputEvent) -> void:
	if not can_create_ball: return
	
	if event is InputEventMouseButton and event.is_pressed():
		if multiplayer.is_server(): 
			create_ball(event.position)
		else:
			create_ball.rpc(event.position)

@rpc("any_peer", "reliable")
func create_ball(pos: Vector2) -> void:
	var ball: RigidBody2D = BALL.instantiate()
	ball.position = pos
	$Balls.add_child(ball, true)
