extends Popup

onready var title = $MarginContainer/VBoxContainer/TextEditTitle
onready var amount = $MarginContainer/VBoxContainer/TextEditAmount

func _on_ButtonOk_pressed():
	var id_period = Database.create_new_period(title.text, amount.text)
	Database.add_payers_to_period(id_period)
	self.hide()


func _on_ButtonCancel_pressed():
	self.hide()
