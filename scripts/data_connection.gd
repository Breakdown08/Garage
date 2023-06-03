extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db
var data_path = "res://data/db"

func _ready():
	db = sqlite.new()
	db.path = data_path
	
	
func print_data():
	db.open_db()
	db.query("select * from owners")
	for i in range(0, db.query_result.size()):
		print(db.query_result[i])

func get_owners():
	db.open_db()
	db.query("select * from owners")
	return db.query_result
		
func insert_data(name:String):
	db.open_db()
	db.query("insert into players (name) values ('"+name+"')")
	
