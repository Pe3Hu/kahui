class_name Processor
extends TileMapLayer


var data: ProcessorData:
	set(value_):
		data = value_
		
		apply_defects()

var tone_to_coords: Dictionary


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2

func apply_defects() -> void:
	tone_to_coords.clear()
	
	for tone in Catalog.tones:
		tone_to_coords[tone] = []
	
	for defect_data in data.defects:
		tone_to_coords[defect_data.tone].append_array(defect_data.coords)
	
	for tone in Catalog.tones:
		var coords = tone_to_coords[tone]
		var terrain = Digest.tone_to_terrain[tone]
		coords.sort()
		set_cells_terrain_connect(coords, 0, terrain, true)
