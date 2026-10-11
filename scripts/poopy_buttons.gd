extends Control

signal host_pressed(username: String)
signal join_pressed(username: String)

@onready var line_edit: LineEdit = $VBoxContainer/LineEdit

func _on_host_pressed() -> void:
	var username = line_edit.text
	host_pressed.emit(username)
	visible = false

func _on_join_pressed() -> void:
	var username = line_edit.text
	join_pressed.emit(username)
	visible = false
