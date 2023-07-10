extends Control

onready var tree = $MarginContainer/Tree
#var texture = "res://src/button.png"
#var test_row = "res://scenes/row.tscn"

onready var checked = load("res://src/checkbox.png")
onready var unchecked = load("res://src/checkbox_empty.png")

func switch_checkbox_state(item: TreeItem):
	if item.get_meta("228")["PAYED"] == true:
		item.add_button(2, unchecked)
	else:
		item.add_button(2, checked)
		
		
		
func instance_owner_row(parent, data) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_cell_mode(2, TreeItem.CELL_MODE_CHECK)
	item.set_checked(2, true)
	item.add_button(2, checked)
	item.set_text(0, data["NAME"])
	item.set_text(1, str(data["GARAGE_NUMBER"])
	#item.set_text(2, str(data["PAYED"]))
	item.set_meta(str(data["ID"]), data)
	return item
	
	
func instance_custom_cell(parent) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
	item.set_text(0, "testtt")
	return item


func _ready():
	tree.columns = 3
	var a_texture: Texture = load("res://src/button.png")
	var root: TreeItem = tree.create_item()
	#root.add_button(0, a_texture)
	root.set_text(0, "Период (март-апрель)")
	for data in Database.get_owners():
		var checkbox: TreeItem = instance_owner_row(root, data)


func _on_Tree_button_pressed(item, column, id):
	print(item, column, id)
	switch_checkbox_state(item)
