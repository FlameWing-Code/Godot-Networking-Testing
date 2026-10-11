extends Node


const IP_ADDRESS = "localhost"
const PORT = 1121


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(on_connection)


func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
func on_connection(id):
	print("OH MY HGOSH!!!! WE CONNECTED WITH THE PERSON WHO CALLS THERMSELVES: " + str(id))
