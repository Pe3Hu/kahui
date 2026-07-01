extends Node


const dice_to_string = {
	Bozo.Dice.FANG: "fang",
	Bozo.Dice.CLAW: "claw",
	Bozo.Dice.TAIL: "tail",
}

const module_to_string = {
	Bozo.Module.HEAD: "head",
	Bozo.Module.TORSO: "torso",
	Bozo.Module.LIMB: "limb",
}

#region tone
const letter_to_tone = {
	"a": Bozo.Tone.RED,
	"b": Bozo.Tone.YELLOW,
	"c": Bozo.Tone.GREEN,
	"d": Bozo.Tone.BLUE,
}

const tone_to_letter = {
	Bozo.Tone.RED: "a",
	Bozo.Tone.YELLOW: "b",
	Bozo.Tone.GREEN: "c",
	Bozo.Tone.BLUE: "d",
}

const tone_to_terrain = {
	Bozo.Tone.RED: 0,
	Bozo.Tone.YELLOW: 1,
	Bozo.Tone.GREEN: 2,
	Bozo.Tone.BLUE: 3,
}
#endregion

#region windrose
const windrose_to_direction = {
	Bozo.Windrose.N : Vector2i(0, -1),
	Bozo.Windrose.E : Vector2i(1, 0),
	Bozo.Windrose.S : Vector2i(0, 1),
	Bozo.Windrose.W : Vector2i(-1, 0),
}

const windrose_to_mirror = {
	Bozo.Windrose.N : Bozo.Windrose.S,
	Bozo.Windrose.E : Bozo.Windrose.W,
	Bozo.Windrose.S : Bozo.Windrose.N,
	Bozo.Windrose.W : Bozo.Windrose.E,
}
#endregion

const outcome_to_frame = {
	Bozo.Outcome.FAILURE: 2,
	Bozo.Outcome.SUCCESS: 1,
	Bozo.Outcome.CRITICAL_SUCCESS: 0
}
