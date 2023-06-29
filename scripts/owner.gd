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


# You can use this function in any Godot project, as long as it has a image file.
func create_file_selected(filepath):
	var image_file = load("res://test_image.jpg");
	image_file = image_file.get_data();
	
	var new_file = File.new();
	new_file.open(filepath, new_file.WRITE);
	new_file.store_var(image_file);
	new_file.close();

# Now delete test_image.jpg, it's .import file, and it's files in the .import folder!
# Then you can load and use the image from anywhere in the file system using the following code:
# (It can even be a completely different project!)

func load_file_selected(filepath):
	var external_file = File.new()
	
	if (external_file.file_exists(filepath)):
		external_file.open(filepath, external_file.READ)
		var bytes = external_file.get_buffer(external_file.get_len())
		var image = Image.new()
		var data = image.load_png_from_buffer(bytes)
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
