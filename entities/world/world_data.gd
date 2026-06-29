class_name WorldData
extends Resource



var encounter: EncounterData = EncounterData.new(self)
var hull: HullData = HullData.new(self)
var processor: ProcessorData = ProcessorData.new(self)


func _init() -> void:
	pass
