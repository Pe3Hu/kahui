class_name AimData
extends Resource


var processor: ProcessorData
var coords: Array[Vector2i]

var raidus: int = 4
var corner_l: int = 2


func _init(processor_: ProcessorData) -> void:
	processor = processor_
	
	init_coords()


func init_coords() -> void:
	coords.clear()
	var indexs = Helper.build_filled_shape(raidus * 2, corner_l)
	
	for index in indexs:
		var coord = Helper.defect_index_to_coord(index, Vector2i.ONE * raidus * 2)
		coords.append(coord)
