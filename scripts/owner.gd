extends Control


func _on_LoadPhotoButton_pressed():
	var dialog = $MarginContainer/FileDialog
	dialog.popup()
	dialog.current_dir = "C://"


func _on_FileDialog_file_selected(path):
	print(path)


func _on_ButtonExit_pressed():
	SceneSwitcher.change_scene(SceneSwitcher.owners_scene)
	
	
func _ready():
	var data = SceneSwitcher.get_param("data")
