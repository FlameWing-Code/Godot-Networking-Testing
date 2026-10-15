extends Node

"""
DATA DICTIONARY = {
	"host_name",
	"port",
	"sender_ip"
}
"""


const DISCOVERY_PORT = 1122
const BROADCAST_IP = "127.0.0.1" # or 255.255.255.255 or 127.0.0.1

signal discovered_new_server(data)

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
var port = 1121

var local_servers: Array[Dictionary] = []
var discovery_peer: PacketPeerUDP
var broadcast_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(on_connection)
	
	discovery_peer = PacketPeerUDP.new()
	discovery_peer.set_broadcast_enabled(true)
	discovery_peer.set_dest_address(BROADCAST_IP, DISCOVERY_PORT)
	var error = discovery_peer.bind(DISCOVERY_PORT)
	print("Discovery bind result: ", error)
	
	broadcast_timer = Timer.new()
	broadcast_timer.wait_time = 1
	broadcast_timer.timeout.connect(broadcast_server_info)
	add_child(broadcast_timer)

func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = peer
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	
	broadcast_timer.start()
	broadcast_server_info()
	
func on_connection(id):
	print("OH MY HGOSH!!!! WE CONNECTED WITH THE PERSON WHO CALLS THERMSELVES: " + str(id))

func broadcast_server_info() -> void:
	var data := {
		"host_name": local_username,
		"port": port
	}
	
	discovery_peer.put_var(data)

func get_available_servers() -> Array:
	while discovery_peer.get_available_packet_count() > 0:
		#print("recieved packet")
		var sender_ip = discovery_peer.get_packet_ip()
		var data = discovery_peer.get_var()
		
		if not sender_ip: continue
		
		if data is Dictionary:
			data["sender_ip"] = sender_ip
			add_to_server_list(data)
	
	return local_servers
	
# adds data to the server list if its new
func add_to_server_list(data) -> void:
	for server in local_servers:
		if server.get("sender_ip") == data.get("sender_ip"):
			return
	local_servers.append(data)
	discovered_new_server.emit(data)
	print(data)
