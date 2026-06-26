class_name EncounterData
extends Resource



var world: WorldData
var pool: PoolData = PoolData.new(self)


func _init(world_: WorldData) -> void:
	world = world_
