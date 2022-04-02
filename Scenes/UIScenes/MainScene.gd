extends Control

func _on_BtnPlay_pressed():
	get_tree().change_scene("res://Scenes/Maps/Map1.tscn")


func _on_BtnQuit_pressed():
	get_tree().quit()
