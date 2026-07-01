class_name Circuit
extends Line2D


@export var data: CircuitData:
	set(value_):
		data = value_
		connect_signals()

@export var processor: Processor


func connect_signals() -> void:
	width = Catalog.CIRCUIT_WIDTH
	if data == null: return
	
	if data.vertexs_changed.is_connected(_on_vertexs_changed):
		data.vertexs_changed.disconnect(_on_vertexs_changed)
	
	data.vertexs_changed.connect(_on_vertexs_changed)
	_on_vertexs_changed()

func _on_vertexs_changed() -> void:
	clear_points()
	points = data.vertexs
