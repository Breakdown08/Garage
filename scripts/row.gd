extends HBoxContainer


func set_visible_button_mode(flag):
	$HBoxContainer/VBoxContainer/ViewPhotoButton.visible = flag


func _on_ViewPhotoButton_pressed():
	print($IndexContainer/Id.text)
	


func _on_ProfileButton_pressed():
	SceneSwitcher.change_scene(SceneSwitcher.profile_scene, {"data":$IndexContainer/Id.text})
