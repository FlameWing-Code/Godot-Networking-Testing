extends Control

signal host_pressed(username: String, adress: String)
signal join_pressed(username: String)

@onready var line_edit: LineEdit = $VBoxContainer/Username
@onready var ipBox = $VBoxContainer/IP

func _on_host_pressed() -> void:
	var username = line_edit.text
	host_pressed.emit(username)
	visible = false

func _on_join_pressed() -> void:
	var username = line_edit.text
	var address = ipBox.text
	join_pressed.emit(username, address)
	visible = false
