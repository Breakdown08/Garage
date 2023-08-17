extends Control

onready var tree = $MarginContainer/VBoxContainer/ScrollContainer/Tree
onready var popup = $Panel/NewPeriodPopup
#var texture = "res://src/button.png"
#var test_row = "res://scenes/row.tscn"

onready var checked = load("res://src/checkbox_checked.png")
onready var unchecked = load("res://src/checkbox_empty.png")

func switch_checkbox_button_state(item: TreeItem):
#	if item.get_meta("228")["PAYED"] == true:
#		item.add_button(2, unchecked)
#	else:
#		item.add_button(2, checked)
	pass
		
func get_payer_status(id_payer):
	var status = Database.get_payer_status(id_payer)
	return bool(status)
	
		
func instance_payer_row(parent, data) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_text(0, data["NAME"])
	item.set_text(1, str(data["GARAGE_NUMBER"]))
	item.add_button(2, checked)
	#item.add_button(2, checked)
	item.set_meta(str(data["ID"]), data)
	item.set_metadata(2, data["ID"])
	return item
	



func _ready():
	tree.columns = 3
	tree.set_select_mode(Tree.SELECT_ROW)
	update_tree()


func _on_Tree_button_pressed(item, column, id):
	print(get_payer_status(item.get_metadata(column)))

	
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
