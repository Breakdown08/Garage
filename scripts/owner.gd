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


func get_file_extention_name(filepath):
	var arr = str(filepath).split('/')
	var filename = arr[len(arr) - 1]
	return str(filename.split('.')[1]).to_lower()

func load_file_selected(filepath):
	var external_file = File.new()
	if (external_file.file_exists(filepath)):
		external_file.open(filepath, external_file.READ)
		var bytes = external_file.get_buffer(external_file.get_len())
		var image = Image.new()
		var extention = get_file_extention_name(filepath)
		var data
		if extention == "png":
			data = image.load_png_from_buffer(bytes)
		else:
			data = image.load_jpg_from_buffer(bytes)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		external_file.close()
		return texture

func _on_FileDialog_file_selected(path):
	counter_photo_field.texture = load_file_selected(path)


func _on_ButtonExit_pressed():
	SceneSwitcher.change_scene(SceneSwitcher.main_scene)
	
	
func _ready():
	id_owner = SceneSwitcher.get_param("id_owner")
	update_fields(id_owner)


func update_fields(id_owner):
	var data = Database.get_owner_with_image(id_owner)
	var texture = Database.load_image_from_data(data)
	name_field.text = str(data["NAME"])
	garage_field.text = str(data["GARAGE_NUMBER"])
	if null != texture:
		counter_photo_field.texture = texture
	counter_photo_id.text = str(data["ID_COUNTER_PHOTO"])
	


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
