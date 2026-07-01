extends Node


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func clear_children(parent_: Node) -> void:
	while parent_.get_child_count() > 0:
		var child = parent_.get_child(0)
		parent_.remove_child(child)
		child.queue_free()

func get_random_key(dict_: Dictionary):
	if dict_.is_empty():
		push_error("empty dictionary in get_random_key")
		return null
	
	var keys = dict_.keys()
	var total = 0.0
	
	for key in keys:
		total += dict_[key]
	
	if total <= 0:
		return null
	
	var r = rng.randf() * total
	var cumulative = 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")

func defect_index_to_coord(index_: int, grid_: Vector2i = Catalog.CORE_CHIP_GRID) -> Vector2i:
	@warning_ignore("integer_division")
	var x = index_ % grid_.x - grid_.x / 2
	@warning_ignore("integer_division")
	var y = index_ / grid_.y - grid_.y / 2
	return Vector2i(x, y)

func edge_sort(windrose_: Bozo.Windrose, a_: Vector2i, b_: Vector2i) -> bool:
	match windrose_:
		Bozo.Windrose.N:
			return a_.x < b_.x
		Bozo.Windrose.E:
			return a_.y < b_.y
		Bozo.Windrose.S:
			return a_.x > b_.x
		Bozo.Windrose.W:
			return a_.y > b_.y
	
	return false


func build_shape_boundary(N: int, k: int) -> Array:
	var S := {}
	
	# 1. Build S = full square minus Ck (corner cuts)
	for y in range(N):
		for x in range(N):
			if not is_in_corners_cut(x, y, N, k):
				S[Vector2i(x, y)] = true
	
	# 2. Extract boundary B
	var B := []
	for p in S.keys():
		if is_boundary(p, S, N):
			B.append(p)
	
	# 3. Center
	var c := Vector2((N - 1) / 2.0, (N - 1) / 2.0)
	
	# 4. Sort by polar angle
	B.sort_custom(func(a, b):
		var ang_a = atan2(a.y - c.y, a.x - c.x)
		var ang_b = atan2(b.y - c.y, b.x - c.x)
		
		if ang_a == ang_b:
			var da = c.distance_to(Vector2(a))
			var db = c.distance_to(Vector2(b))
			return da < db
		return ang_a < ang_b
	)
	
	# 5. Convert to linear indices
	var res := []
	for p in B:
		res.append(p.y * N + p.x)
	
	return res

func build_filled_shape(N: int, k: int) -> Array:
	var allowed := {}
	
	# 1. Build allowed region (S0 \ Ck)
	for y in range(N):
		for x in range(N):
			if not is_in_corners_cut(x, y, N, k):
				allowed[Vector2i(x, y)] = true
	
	# 2. Flood fill from center (ensures connectivity "inside")
	@warning_ignore("integer_division")
	var start = Vector2i(N / 2, N / 2)
	if not allowed.has(start):
		# fallback: find any valid seed
		for p in allowed.keys():
			start = p
			break
	
	var q = []
	var visited = {}
	var result = []
	
	q.append(start)
	visited[start] = true
	
	var dirs = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(1, -1),
		Vector2i(-1, 1), Vector2i(-1, -1)
	]
	
	while q.size() > 0:
		var p = q.pop_front()
		result.append(p.y * N + p.x)
		
		for d in dirs:
			var n = p + d
			if n.x < 0 or n.y < 0 or n.x >= N or n.y >= N:
				continue
			if visited.has(n):
				continue
			if not allowed.has(n):
				continue
			
			visited[n] = true
			q.append(n)
	
	return result

# ====== CHECK IF IN CUT CORNERS Ck ======
func is_in_corners_cut(x: int, y: int, N: int, k: int) -> bool:
	return (x + y < k) \
		or ((N - 1 - x) + y < k) \
		or (x + (N - 1 - y) < k) \
		or ((N - 1 - x) + (N - 1 - y) < k)


# ====== BOUNDARY CHECK (8-neighborhood) ======
func is_boundary(p: Vector2i, S: Dictionary, N: int) -> bool:
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var q = Vector2i(p.x + dx, p.y + dy)
			if q.x < 0 or q.y < 0 or q.x >= N or q.y >= N:
				return true
			if not S.has(q):
				return true
	return false
