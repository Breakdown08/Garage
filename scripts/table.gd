extends Control

var row = preload("res://scenes/row.tscn")
onready var table = get_node("VBoxContainer/BodyContainer/ScrollContainer/VBoxContainer")

var sn = 0


func set_data(data:Dictionary):
	sn += 1
	var instance = row.instance()
	instance.name = "Row" + str(sn)
	table.add_child(instance)
	var parent_path = str(instance.get_parent().get_path()) + "/"	
	get_node(parent_path + instance.name + "/IndexContainer/Id").text = str(data.ID)
	get_node(parent_path + instance.name + "/IndexContainer/Label").text = str(sn)
	get_node(parent_path + instance.name + "/NameContainer/Label").text = str(data.NAME)
	get_node(parent_path + instance.name + "/GarageContainer/Label").text = str(data.GARAGE_NUMBER)
	
func update_table():
	clear_table()
	sn = 0
	var owners = Database.get_owners()
	for owner in owners:
		set_data(owner)

func clear_table():
	var children = table.get_children()
	for child in children:
		table.remove_child(child)
	

func _ready():
	update_table()
