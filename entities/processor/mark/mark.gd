class_name Mark
extends Sprite2D


var data: MarkData:
	set(value_):
		data = value_
		
		connect_signals()

@export var processor: Processor


func connect_signals() -> void:
	if data == null: return
	
	if data.coord_changed.is_connected(_on_coord_changed):
		data.coord_changed.disconnect(_on_coord_changed)
	
	data.coord_changed.connect(_on_coord_changed)
	_on_coord_changed()

func _on_coord_changed() -> void:
	visible = data.is_visible
	position = (Vector2(data.coord) + Vector2.ONE * 0.5) * Catalog.CHIP_SIZE
	frame = Digest.outcome_to_frame[data.outcome]
