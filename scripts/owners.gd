extends Control

onready var table = $ScrollContainer/MarginContainer/VBoxContainer/Table

func _ready():
	pass


func _on_NewOwnerButton_pressed():
	Database.create_new_owner()
	table.update_table()
