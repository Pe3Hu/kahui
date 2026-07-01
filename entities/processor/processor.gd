class_name Processor
extends Node2D


var data: ProcessorData:
	set(value_):
		data = value_
		
		connect_signals()
		apply_defects()
		apply_aim()
		mark.data = data.mark

@export var mark: Mark



#region init
func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2

func connect_signals() -> void:
	if data == null: return
	
	if data.coords_changed.is_connected(_on_coords_changed):
		data.coords_changed.disconnect(_on_coords_changed)
	
	data.coords_changed.connect(_on_coords_changed)

func _on_coords_changed(edge_: EdgeData) -> void:
	match edge_.defect.trend:
		Bozo.Trend.DECAY:
			%Defect.set_cells_terrain_connect(edge_.coords, 0, -1)
			%Background.set_cells_terrain_connect(edge_.coords, 0, -1)
		Bozo.Trend.GROWTH:
			var tone = edge_.defect.tone
			update_terrain(tone)
	
	edge_.defect.trend = Bozo.Trend.NONE

func apply_defects() -> void:
	for tone in Catalog.tones:
		update_terrain(tone)

func update_terrain(tone_: Bozo.Tone) -> void:
	var coords = data.tone_to_coords[tone_]
	var terrain = Digest.tone_to_terrain[tone_]
	%Defect.set_cells_terrain_connect(coords, 0, terrain, true)
	%Background.set_cells_terrain_connect(data.coords, 0, 0, true)

func apply_aim() -> void:
	%Aim.set_cells_terrain_connect(data.aim.coords, 0, 0, true)
#endregion



func _input(event) -> void:
	if event is InputEventKey and event.pressed: 
		match event.keycode:
			KEY_W:
				data.growth_defect(Bozo.Windrose.N)
			KEY_D:
				data.growth_defect(Bozo.Windrose.E)
			KEY_S:
				data.growth_defect(Bozo.Windrose.S)
			KEY_A:
				data.growth_defect(Bozo.Windrose.W)
			KEY_T:
				data.decay_defect(Bozo.Windrose.S)
			KEY_H:
				data.decay_defect(Bozo.Windrose.W)
			KEY_G:
				data.decay_defect(Bozo.Windrose.N)
			KEY_F:
				data.decay_defect(Bozo.Windrose.E)
