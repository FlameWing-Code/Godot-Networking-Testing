class_name DiscoveredServerItem
extends PanelContainer

signal button_pressed(ip)

@onready var host_label = $VBoxContainer/Host
@onready var port_label = $VBoxContainer/Port
@onready var ip_label = $VBoxContainer/IP

var data: Dictionary

func set_host(value: String) -> void:
	host_label.text = "Host: " + value
	
func set_port(value) -> void:
	port_label.text = "Port: " + str(value)
	
func set_ip(value: String) -> void:
	ip_label.text = "IP: " + value
	
func set_data(data: Dictionary) -> void:
	if not data: return
	
	self.data = data
	
	set_host(data.get("host_name"))
	set_port(data.get("port"))
	set_ip(data.get("sender_ip"))

func _on_button_pressed() -> void:
	button_pressed.emit(data.get("sender_ip"))
