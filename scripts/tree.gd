extends Control

onready var tree = $MarginContainer/VBoxContainer/ScrollContainer/Tree
onready var popup = $Panel/NewPeriodPopup
#var texture = "res://src/button.png"
#var test_row = "res://scenes/row.tscn"

onready var checked = load("res://src/checkbox_checked.png")
onready var unchecked = load("res://src/checkbox_empty.png")

func switch_checkbox_state(item: TreeItem):
#	if item.get_meta("228")["PAYED"] == true:
#		item.add_button(2, unchecked)
#	else:
#		item.add_button(2, checked)
	pass
		
		
		
func instance_payer_row(parent, data) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_cell_mode(2, TreeItem.CELL_MODE_CHECK)
	item.set_metadata(2, "test")
	
	#item.set_checked(2, false)
	
	item.set_text(0, data["NAME"])
	item.set_text(1, str(data["GARAGE_NUMBER"]))
	#item.add_button(3, checked)
	#item.
	#item.set_text(2, str(data["IS_CLOSED"]))
	item.set_meta(str(data["ID"]), data)
	return item
	
	
#func instance_custom_cell(parent) -> TreeItem:
#	var item = tree.create_item(parent)
#	item.set_cell_mode(0, TreeItem.CELL_MODE_CUSTOM)
#	item.set_text(0, "testtt")
#	return item


func _ready():
	tree.columns = 3
	update_tree()


func _on_Tree_button_pressed(item, column, id):
	print("test")


func _on_Tree_cell_selected():
	var item: TreeItem = tree.get_selected()
	
	if item.is_selected(2) and !item.is_selected(1) and !item.is_selected(0):
		var meta = item.get_metadata(2)
		if meta:
			print(meta)

func _on_Tree_item_selected():
	pass
	#print(tree.get_selected())
	
func create_new_period(period):
	var root: TreeItem = tree.create_item()
	root.set_text(0, period["TITLE"])
	var header = tree.create_item(root)
	header.set_text(0, "ФИО плательщика")
	header.set_text(1, "Номер гаража")
	header.set_text(2, "Статус оплачено")
	for data in Database.get_payers():
		var checkbox: TreeItem = instance_payer_row(root, data)

func update_tree():
	var root: TreeItem = tree.create_item()
	root.set_text(0, "Платежные периоды")
	for period in Database.get_periods():
		create_new_period(period)


func _on_NewPeriodButton_pressed():
	popup.show()


func _on_NewPeriodPopup_popup_hide():
	pass


func _on_Tree_item_custom_button_pressed():
	#print(tree.get_selected())
	pass


func _on_Tree_gui_input(event):
	pass
