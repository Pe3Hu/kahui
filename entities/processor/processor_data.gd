class_name ProcessorData
extends Resource


@warning_ignore("unused_signal")
signal coords_changed(edge_: EdgeData)

var world: WorldData
var core: CoreData
var aim: AimData = AimData.new(self)
var mark: MarkData = MarkData.new(self)

var defects: Array[DefectData]

var coords: Array[Vector2i]

var tone_to_coords: Dictionary
var current_defect_index: int = 6

var radius_to_circuit: Dictionary


#region init
func _init(world_: WorldData) -> void:
	world = world_
	core = load("res://entities/processor/core/datas/1.tres")
	
	init_defects()
	init_tones()
	test_decay()
	mark.roll_coord()

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

func init_tones() -> void:
	tone_to_coords.clear()
	
	for tone in Catalog.tones:
		tone_to_coords[tone] = []
	
	for defect in defects:
		tone_to_coords[defect.tone].append_array(defect.coords)
#endregion

#region trend
func growth_defect(windrose_: Bozo.Windrose) -> void:
	var defect = defects[current_defect_index]
	defect.growth(windrose_)

func decay_defect(windrose_: Bozo.Windrose) -> void:
	var defect = defects[current_defect_index]
	defect.decay(windrose_)
#endregion

func test_decay() -> void:
	
	for defect in defects:
		var options: Array
		options.append_array(Catalog.orthogonal_windroses)
		options.shuffle()
		
		for windrose in options:
			for _i in 3:
				defect.decay(windrose)
