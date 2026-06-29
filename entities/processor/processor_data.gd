class_name ProcessorData
extends Resource


var world: WorldData
var defects: Array[DefectData]
var core: CoreData


func _init(world_: WorldData) -> void:
	world = world_
	core = load("res://entities/processor/core/datas/0.tres")
	
	init_defects()

func init_defects() -> void:
	for tone in Catalog.tones:
		for _i in Catalog.CORE_TONE_COUNT:
			add_defect(tone, _i + 1)

func add_defect(tone_: Bozo.Tone, index_: int) -> void:
	var letter = Digest.tone_to_letter[tone_]#Bozo.enum_to_string(Bozo.Type.TONE, tone_)
	var path = "%s%d" % [letter, index_]
	var indexs = core.get(path)
	var defect = DefectData.new(self, tone_, indexs)
	defects.append(defect)
