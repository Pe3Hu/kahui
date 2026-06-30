class_name DefectData
extends Resource


var processor: ProcessorData
var tone: Bozo.Tone
#var indexs: Array[int]

var coords: Array[Vector2i]
var internals: Array[Vector2i]
var externals: Array[Vector2i]

var left_top: Vector2i = Vector2i.ONE * 100
var right_bot: Vector2i = Vector2i.ONE * -100
var dimensions: Vector2i

var edges: Array[EdgeData]
var windorse_to_edge: Dictionary

var center: Vector2
var anchors: Array[Vector2i]

var trend: Bozo.Trend


#region init
func _init(processor_: ProcessorData, tone_: Bozo.Tone, indexs_: Array[int]) -> void:
	processor = processor_
	tone = tone_
	
	init_coords(indexs_)
	init_edges()

func init_coords(indexs_: Array[int]) -> void:
	center = Vector2.ZERO
	
	for index in indexs_:
		var coord = Helper.defect_index_to_coord(index)
		coords.append(coord)
		
		if processor.core.anchors.has(index):
			anchors.append(coord)
			center += Vector2(coord)
		
		if left_top.x >= coord.x and left_top.y >= coord.y:
			left_top = coord
		if right_bot.x <= coord.x and right_bot.y <= coord.y:
			right_bot = coord
	
	
	center /= anchors.size()
	dimensions = right_bot - left_top + Vector2i.ONE
	
	processor.coords.append_array(coords)
	init_externals()

func init_externals() -> void:
	internals.clear()
	externals.clear()
	
	if dimensions.x <= 2 or dimensions.y <= 2:
		externals.append_array(coords)
		return
	
	for coord in coords:
		if   left_top.x >= coord.x or \
			 left_top.y >= coord.y or \
			right_bot.x <= coord.x or \
			right_bot.y <= coord.y:
			externals.append(coord)
		else:
			internals.append(coord)

func init_edges() -> void:
	for windrose in Catalog.orthogonal_windroses:
		add_edge(windrose)
	
	inin_neighbours()

func inin_neighbours() -> void:
	var n = edges.size()
	
	for _i in n:
		var _j = (_i - 1 + n) % n
		var _l = (_i + 1) % n
		var indexs = [_j, _l]
		
		var edge = edges[_i]
		
		for index in indexs:
			var neighbour = edges[index]
			edge.neighbours.append(neighbour)

func add_edge(windrose_: Bozo.Windrose) -> void:
	var edge = EdgeData.new(self, windrose_)
	edges.append(edge)
	windorse_to_edge[windrose_] = edge
#endregion

#region trend
func growth(windrose_: Bozo.Windrose) -> void:
	var edge = windorse_to_edge[windrose_]
	edge.growth()

func decay(windrose_: Bozo.Windrose) -> void:
	var edge = windorse_to_edge[windrose_]
	edge.decay()
#endregion
