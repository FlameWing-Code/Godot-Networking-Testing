extends Node

const PORT = 1121
const DISCOVERY_PORT = 1122
const BROADCAST_IP = "127.0.0.1" # or 255.255.255.255

var local_username: String = "":
	set(value):
		local_username = value.strip_edges()
	get:
		if not local_username.is_empty():
			return local_username
		else:
			return str(multiplayer.get_unique_id())
			
var local_username_color = Color.from_hsv(randf(), randf(), randf())
var ip_address = "localhost"

var discovery_peer: PacketPeerUDP
var broadcast_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(on_connection)
	
	discovery_peer = PacketPeerUDP.new()
	discovery_peer.set_broadcast_enabled(true)
	discovery_peer.set_dest_address("127.0.0.1", DISCOVERY_PORT)
	discovery_peer.bind(DISCOVERY_PORT)
	
	broadcast_timer = Timer.new()
	broadcast_timer.wait_time = 1
	broadcast_timer.timeout.connect(broadcast_server_info)
	add_child(broadcast_timer)
	
var time := 0.0
func _process(delta: float) -> void:
	time += delta
	if time >= 1:
		print(get_available_servers())
		time = 0

func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	broadcast_timer.start()
	
func on_connection(id):
	print("OH MY HGOSH!!!! WE CONNECTED WITH THE PERSON WHO CALLS THERMSELVES: " + str(id))

func broadcast_server_info() -> void:
	var data := {
		"host_name": local_username,
		"port": PORT
	}
	
	discovery_peer.put_var(data)

func get_available_servers() -> Array:
	var array = []
	
	while discovery_peer.get_available_packet_count() > 0:
		print("recieved packet")
		var sender_ip = discovery_peer.get_packet_ip()
		var data = discovery_peer.get_var()
		
		if data is Dictionary:
			data["sender_ip"] = sender_ip
			array.append(data)
	
	return array
