extends Node




enum Circumstance {
	NONE = 0,
	DOMINANCE = 1,
	HINDRANCE = 2,
}

enum Dice {
	NONE = 0,
	FANG = 3,
	CLAW = 4,
	TAIL = 5,
}

enum Module {
	NONE = 0,
	HEAD = 6,
	TORSO = 7,
	LIMB = 8,
}

enum Tone {
	NONE = 0,
	RED = 9,
	YELLOW = 10,
	GREEN = 11,
	BLUE = 12
}


#region string
enum Type {
	NONE = 0,
	CIRCUMSTANCE = -1,
	DICE = -2,
	MODULE = -3,
	TONE = -4,
}

const type_to_index = {
	Type.NONE: 0,
	Type.CIRCUMSTANCE: 1,
	Type.DICE: 3,
	Type.MODULE: 6,
	Type.TONE: 9,
}

const type_to_enum = {
	Type.CIRCUMSTANCE: Bozo.Circumstance,
	Type.DICE: Bozo.Dice,
	Type.MODULE: Bozo.Module,
	Type.TONE: Bozo.Tone,
}

func enum_to_string(type_: Variant, value_: int) -> String:
	var index = value_ - type_to_index[type_] + 1
	var enum_ = type_to_enum[type_]
	var key_name: String = enum_.keys()[index]
	
	if key_name:
		return key_name.to_lower()
	
	return "unknown"
#endregion
