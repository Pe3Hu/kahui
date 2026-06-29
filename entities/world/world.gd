class_name World
extends Node


var data = WorldData.new()


func _ready() -> void:
	%Processor.data = data.processor
	

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
	
