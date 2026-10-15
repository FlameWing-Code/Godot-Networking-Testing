extends Control

signal host_pressed(username: String, adress: String)
signal join_pressed(username: String, address: String)

const DISCOVERED_SERVER_ITEM = preload("res://scenes/discovered_server_item.tscn")
@onready var line_edit: LineEdit = $VBoxContainer/Username
@onready var ipBox = $VBoxContainer/IP
@onready var get_servers_timer = $GetServersTimer
@onready var local_servers_container = $ScrollContainer/LocalServers


func _ready() -> void:
	NetworkManager.discovered_new_server.connect(create_discovered_server_item)
	
	for data in NetworkManager.get_available_servers():
		create_discovered_server_item(data)

func _on_host_pressed() -> void:
	var username = line_edit.text
	host_pressed.emit(username)
	visible = false

func _on_join_pressed() -> void:
	var username = line_edit.text
	var address = ipBox.text
	join_pressed.emit(username, address)
	visible = false

func _on_get_servers_timer_timeout() -> void:
	print(NetworkManager.get_available_servers())

func create_discovered_server_item(data) -> void:
	print("creating thing")
	var item: DiscoveredServerItem = DISCOVERED_SERVER_ITEM.instantiate()
	local_servers_container.add_child(item)
	item.set_data(data)
	
	item.button_pressed.connect(_on_specific_server_button_join)
	
func _on_specific_server_button_join(ip):
	var username = line_edit.text
	var address = ip
	join_pressed.emit(username, address)
	visible = false
