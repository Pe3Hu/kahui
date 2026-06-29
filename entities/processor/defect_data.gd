class_name DefectData
extends Resource


var processor: ProcessorData
var tone: Bozo.Tone
#var indexs: Array[int]

var coords: Array[Vector2i]
#var dimensions: Vector2i

func _init(processor_: ProcessorData, tone_: Bozo.Tone, indexs_: Array[int]) -> void:
	processor = processor_
	tone = tone_
	
	init_coords(indexs_)

func init_coords(indexs_: Array[int]) -> void:
	for index in indexs_:
		var coord = Helper.defect_index_to_coord(index)
		coords.append(coord)
