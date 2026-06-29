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
