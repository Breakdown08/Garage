extends Control

onready var tree = $MarginContainer/VBoxContainer/ScrollContainer/Tree
onready var popup = $Panel/NewPeriodPopup

onready var checked = load("res://src/checkbox_checked.png")
onready var unchecked = load("res://src/checkbox_empty.png")

func draw_checkbox_button_state(item: TreeItem, flag: bool):
	if flag:
		item.set_button(2, 0, checked)
	else:
		item.set_button(2, 0, unchecked)

func switch_payer_status(id_payer):
	var payer_status = get_payer_status(id_payer)
	Database.set_payer_status(id_payer, int(!payer_status))
		
func get_payer_status(id_payer):
	var status = Database.get_payer_status(id_payer)
	return status
		
func instance_payer_row(parent, data) -> TreeItem:
	var item = tree.create_item(parent)
	item.set_text(0, data["NAME"])
	item.set_text(1, str(data["GARAGE_NUMBER"]))
	if bool(get_payer_status(data["ID"])):
		item.add_button(2, checked)
	else:
		item.add_button(2, unchecked)
	item.set_meta(str(data["ID"]), data)
	item.set_metadata(2, data["ID"])
	return item
	
func _ready():
	tree.columns = 3
	tree.set_select_mode(Tree.SELECT_ROW)
	update_tree()

func _on_Tree_button_pressed(item, column, id):
	item.select(0)
	var id_payer = item.get_metadata(column)
	switch_payer_status(id_payer)
	var flag = bool(get_payer_status(id_payer))
	draw_checkbox_button_state(item, flag)
	var root = item.get_parent()
	var children = get_all_children(root)
	var footer = children[len(children) - 1]
	footer.set_text(2, set_footer_value(root.get_meta("period_data")["ID"]))

	
func calculate_period_amount(id_period):
	var payers = Database.get_payers(id_period)
	var amount = Database.get_period_amount(id_period)
	print(amount)
	var one_person_collection = int(amount / len(payers))
	var current_amount = 0
	for payer in payers:
		if bool(payer["IS_CLOSED"]):
			current_amount += one_person_collection
	return str(current_amount) + " / " + str(amount)
	
func create_new_period(period):
	var root: TreeItem = tree.create_item()
	root.set_text(0, period["TITLE"])
	var header = tree.create_item(root)
	header.set_text(0, "ФИО плательщика")
	header.set_text(1, "Номер гаража")
	header.set_text(2, "Статус оплачено")
	root.set_meta("period_data", period)
	for data in Database.get_payers(period["ID"]):
		var checkbox: TreeItem = instance_payer_row(root, data)
	var footer = tree.create_item(root)
	footer.set_text(2, set_footer_value(root.get_meta("period_data")["ID"]))

func update_tree():
	var root: TreeItem = tree.create_item()
	root.set_text(0, "Платежные периоды")
	for period in Database.get_periods():
		create_new_period(period)
		calculate_period_amount(period["ID"])

func _on_NewPeriodButton_pressed():
	popup.show()


func _on_Tree_item_selected():
	print(tree.get_selected())
	
func get_all_children(root):
	var stop_search = false
	var item
	var arr = []
	item = root.get_children()
	while(!stop_search):
		if item and item.get_parent() == root:
			arr.push_back(item)
			item = item.get_next()
		else:
			stop_search = true
	return arr

func set_footer_value(id_period):
	return "Собрано: " + calculate_period_amount(id_period)
