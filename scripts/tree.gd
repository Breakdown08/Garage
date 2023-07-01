extends Control

onready var tree = $MarginContainer/Tree
#var texture = "res://src/button.png"
#var test_row = "res://scenes/row.tscn"

func instance_owner_row(parent) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_cell_mode(2, TreeItem.CELL_MODE_CHECK)
	item.set_checked(2, true)
	item.add_button(2, load("res://src/button.png"))
	item.set_text(0,"Иванов Иван Иванович")
	item.set_text(1,"№4")
	item.set_text(2,"оплачено")
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
	var checkbox: TreeItem = instance_owner_row(root)
	


func _on_Tree_button_pressed(item, column, id):
	print(item, column, id)
