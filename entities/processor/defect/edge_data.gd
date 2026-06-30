class_name EdgeData
extends Resource


var defect: DefectData
var windrose: Bozo.Windrose

var coords: Array[Vector2i]
var neighbours: Array[EdgeData]


#region init
func _init(defect_: DefectData, windrose_: Bozo.Windrose) -> void:
	defect = defect_
	windrose = windrose_
	
	init_coords()

func init_coords() -> void:
	for coord in defect.externals:
		var flag: bool = false
		
		match windrose:
			Bozo.Windrose.N:
				flag = defect.left_top.y == coord.y
			Bozo.Windrose.E:
				flag = defect.right_bot.x == coord.x
			Bozo.Windrose.S:
				flag = defect.right_bot.y == coord.y
			Bozo.Windrose.W:
				flag = defect.left_top.x == coord.x
		
		if flag:
			coords.append(coord)
	
	
	if coords.is_empty():
		pass
#endregion

#region growth
func can_growth() -> bool:
	var direction = Digest.windrose_to_direction[windrose]
	
	for coord in coords:
		var growth_coord = coord + direction
		
		if defect.processor.coords.has(growth_coord):
			return false
	
	return true

func growth() -> void:
	if !can_growth(): return
	defect.trend = Bozo.Trend.GROWTH
	var direction = Digest.windrose_to_direction[windrose]
	var new_coords: Array[Vector2i]
	
	for _i in coords.size():
		var coord = coords[_i]
		var growth_coord = coord + direction
		new_coords.append(growth_coord)
		defect.coords.append(growth_coord)
		
		if _i > 0 and _i < coords.size() - 1:
			defect.externals.erase(coord)
			defect.internals.append(coord)
			defect.externals.append(growth_coord)
		
		defect.processor.coords.append(growth_coord)
		defect.processor.tone_to_coords[defect.tone].append(growth_coord)
	
	coords.clear()
	coords.append_array(new_coords)
	coords.sort_custom(func (a,b): return Helper.edge_sort(windrose, a, b))
	defect.processor.emit_signal("coords_changed", self)
	
	var neighbour = neighbours.front()
	var corner_coord = coords.front()
	neighbour.coords.append(corner_coord)
	neighbour = neighbours.back()
	corner_coord = coords.back()
	neighbour.coords.append(corner_coord)
#endregion

func can_decay() -> bool:
	if is_last_edge(): return false
	if is_anchor(): return false
	#var mirror = Digest.windrose_to_mirror[windrose]
	#var direction = Digest.windrose_to_direction[mirror]
	#
	#for coord in coords:
		#var decay_coord = coord + direction
		#
		#if defect.anchors.has(decay_coord):
			#return false
	
	return true

func decay() -> void:
	if !can_decay(): return
	defect.trend = Bozo.Trend.DECAY
	var mirror = Digest.windrose_to_mirror[windrose]
	var direction = Digest.windrose_to_direction[mirror]
	var new_coords: Array[Vector2i]
	
	var neighbour = neighbours.front()
	var corner_coord = coords.front()
	neighbour.coords.erase(corner_coord)
	neighbour = neighbours.back()
	corner_coord = coords.back()
	neighbour.coords.erase(corner_coord)
	
	for _i in coords.size():
		var coord = coords[_i]
		var decay_coord = coord + direction
		new_coords.append(decay_coord)
		
		if _i > 0 and _i < coords.size() - 1:
			defect.externals.erase(coord)
			defect.internals.erase(decay_coord)
			defect.externals.append(decay_coord)
		
		defect.coords.erase(coord)
		defect.externals.erase(coord)
		defect.processor.coords.erase(coord)
		defect.processor.tone_to_coords[defect.tone].erase(coord)
	
	defect.processor.emit_signal("coords_changed", self)
	
	coords.clear()
	coords.append_array(new_coords)
	coords.sort_custom(func (a,b): return Helper.edge_sort(windrose, a, b))

func is_last_edge() -> bool:
	var neighbour = neighbours.front()
	return neighbour.coords.size() == 1

func is_anchor() -> bool:
	for coord in coords:
		if defect.anchors.has(coord):
			return true
	
	return false
