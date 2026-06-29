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
	var total := 0.0
	
	for key in keys:
		total += dict_[key]
	
	if total <= 0:
		return null
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")

func defect_index_to_coord(index_: int) -> Vector2i:
	@warning_ignore("integer_division")
	var x = index_ % Catalog.CORE_CHIP_SIZE.x - Catalog.CORE_CHIP_SIZE.x / 2
	@warning_ignore("integer_division")
	var y = index_ / Catalog.CORE_CHIP_SIZE.y - Catalog.CORE_CHIP_SIZE.y / 2
	return Vector2i(x, y)
