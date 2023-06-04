extends Control

onready var name_field = $ScrollContainer/MarginContainer/VBoxContainer/NameContainer/VBoxContainer/LineEdit
onready var garage_field = $ScrollContainer/MarginContainer/VBoxContainer/GarageContainer/VBoxContainer/LineEdit
onready var counter_photo_field = $ScrollContainer/MarginContainer/VBoxContainer/PhotoContainer/VBoxContainer/CenterContainer2/TextureRect
onready var counter_photo_id = $ScrollContainer/MarginContainer/VBoxContainer/PhotoContainer/VBoxContainer/CenterContainer2/Label
var id_owner

func _on_LoadPhotoButton_pressed():
	var dialog = $MarginContainer/FileDialog
	dialog.popup()
	dialog.current_dir = OS.get_executable_path()
	for item in Database.get_images():
		counter_photo_field.texture = Database.load_image_from_data(item)

func _on_FileDialog_file_selected(path):
	#var test_path = "C://Users/user/Desktop/SNIMOK.PNG"
	print(path)
	counter_photo_field.texture = load(path)
	#var id_image = Database.save_image_to_db(counter_photo_field.texture)
	#if null != id_image:
	#	Database.set_image_to_owner(id_owner, id_image)


func _on_ButtonExit_pressed():
	SceneSwitcher.change_scene(SceneSwitcher.main_scene)
	
	
func _ready():
	id_owner = SceneSwitcher.get_param("id_owner")
	update_fields(id_owner)


func update_fields(id_owner):
	var data = Database.get_owner_with_image(id_owner)
	var texture = Database.load_image_from_data(owner)
	for owner in data:
		name_field.text = str(owner["NAME"])
		garage_field.text = str(owner["GARAGE_NUMBER"])
		if null != texture:
			counter_photo_field.texture = texture
		counter_photo_id.text = str(owner["ID_COUNTER_PHOTO"])
	


func _on_DeleteButton_pressed():
	$MarginContainer/ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	Database.remove_owner(id_owner)
	SceneSwitcher.change_scene(SceneSwitcher.main_scene)


func _on_SaveButton_pressed():
	var data = {
		"NAME": str(name_field.text),
		"GARAGE_NUMBER": str(garage_field.text),
		"ID_COUNTER_PHOTO": str(counter_photo_id.text)
	}
	Database.save_owner_data(id_owner, data)


func _on_FileDialog_popup_hide():
	update_fields(id_owner)
