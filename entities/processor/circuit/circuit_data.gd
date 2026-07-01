class_name CircuitData
extends Resource


signal vertexs_changed

var processor: ProcessorData

@export var raidus: int = 3:
	set(value_):
		raidus = value_
		update_vertexs()
@export var corner_l: int = 2

var vertexs: Array[Vector2]
var coords: Array[Vector2i]


func _init() -> void:
	update_vertexs()


func update_vertexs() -> void:
	vertexs.clear()
	coords.clear()
	
	#for defect in processor.defects:
	#	for coord in defect.externals:
	#for coord in processor.coords:
	#	if is_external(coord):
	#		coords.append(coord)
	var indexs = Helper.build_shape_boundary(raidus * 2, corner_l)
	for index in indexs:#Catalog.circuit_indexs:
		var coord = Helper.defect_index_to_coord(index, Vector2i.ONE * raidus * 2)
		coords.append(coord)
	
	coords.sort_custom(func (a, b): return Vector2(a).angle() > Vector2(b).angle())
	
	#var n = coords.size()
	#
	#for _i in range(n - 1, -1, -1):
		#var _j = (_i + 1) % n
		#var coord_a = coords[_i]
		#var coord_b = coords[_j]
		#var coord_c = Vector2i(coord_a.x, coord_b.y)
		#var coord_d = Vector2i(coord_b.x, coord_a.y)
		#
		#if processor.coords.has(coord_c):
			#coords.append(coord_c)
			#continue
		#if processor.coords.has(coord_d):
			#coords.append(coord_d)
			#continue
	
	for coord in coords:
		var vertex = Vector2(coord)
		var x = 0.5
		var y = 0.5
		
		if Catalog.PROCESSOR_CENTER.x > vertex.x:
			x *= -1
		if Catalog.PROCESSOR_CENTER.x > vertex.y:
			y *= -1
		
		vertex += Vector2(x, y) 
		vertex *= Catalog.CHIP_SIZE
		vertex += Catalog.CHIP_SIZE * 0.5
		#vertex += Vector2(x, y) * Catalog.CIRCUIT_WIDTH
		vertexs.append(vertex)
	
	vertexs.sort_custom(func (a, b): return a.angle() > b.angle())
	emit_signal("vertexs_changed")

func is_external(coord_: Vector2i) -> bool:
	for direction in Catalog.orthogonal_directions:
		var coord_neighbour = direction + coord_
		
		if !processor.coords.has(coord_neighbour):
			return true
	
	return false
