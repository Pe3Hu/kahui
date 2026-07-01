class_name MarkData
extends Resource


signal coord_changed

var processor: ProcessorData
var outcome: Bozo.Outcome
var coord: Vector2i:
	set(value_):
		coord = value_
		emit_signal("coord_changed")

var is_visible: bool = false:
	set(value_):
		is_visible = value_
		emit_signal("coord_changed")


func _init(processor_: ProcessorData) -> void:
	processor = processor_

func roll_coord() -> void:
	is_visible = true
	coord = processor.aim.coords.pick_random() #Vector2i(-1, -1) * 3#Vector2i(1, 0)#
	
	if processor.coords.has(coord):
		if processor.tone_to_coords[Bozo.Tone.RED].has(coord):
			outcome = Bozo.Outcome.FAILURE
			return
		outcome = Bozo.Outcome.SUCCESS
	else:
		outcome = Bozo.Outcome.CRITICAL_SUCCESS
