extends Control

var row = preload("res://scenes/row.tscn")
onready var table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")

var sn = 0


func set_data(data:Dictionary):
	sn += 1
	var instance = row.instance()
	instance.name = "row" + str(sn)
	table.add_child(instance)
	#instance.connect("pressed", self, "on_button_pressed")
	
	var path_to_node = "VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"
	
	get_node(path_to_node + instance.name + "/Label1").text = str(sn)
	get_node(path_to_node + instance.name + "/Label2").text = str(data.NAME)
	get_node(path_to_node + instance.name + "/Label3").text = str(data.GARAGE_NUMBER)
	path_to_node += instance.name + "/Label1"
	
func update_table():
	sn = 0
	var owners = Database.get_owners()
	for owner in owners:
		set_data(owner)

	
func _ready():
	update_table()
		
