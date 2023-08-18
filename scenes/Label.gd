extends Label

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

func _ready():
	var db_test = sqlite.new()
	db_test.path = "res://database"
	self.text = str(db_test.open_db())
