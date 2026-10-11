extends Control

const MESSAGE_SCENE = preload("res://scenes/message.tscn")
@onready var message_container: VBoxContainer = $VBoxContainer/ScrollContainer/MessageContainer
@onready var scroll_container: ScrollContainer = $VBoxContainer/ScrollContainer
@onready var line_edit: LineEdit = $VBoxContainer/LineEdit

func make_pretty_text(username: String, name_color: String, message_text: String) -> String:
	var text: String = "[color={name_color}]{username}[/color]: {message_text}"
	return text.format({"username" = username, "name_color" = name_color, "message_text" = message_text})

@rpc("any_peer", "call_local", "reliable", 1)
func new_message(text) -> void:
	var message: RichTextLabel = MESSAGE_SCENE.instantiate()
	
	message.text = text
	message_container.add_child(message, true)

func _on_line_edit_text_submitted(new_text: String) -> void:
	print("recieved message: " + new_text)
	var text = make_pretty_text(NetworkManager.local_username, "red", new_text)
	new_message.rpc(text)
	
	line_edit.clear()
