extends Node


const POOL_DICE_COUNT: int = 2

#region tone
const tones = [
	Bozo.Tone.RED,
	Bozo.Tone.YELLOW,
	Bozo.Tone.GREEN,
	Bozo.Tone.BLUE,
]

const CORE_TONE_COUNT: int = 2
const CORE_CHIP_GRID: Vector2i = Vector2i(6, 6)
#endregion


#region windrose
const orthogonal_windroses = [
	Bozo.Windrose.N,
	Bozo.Windrose.E,
	Bozo.Windrose.S,
	Bozo.Windrose.W,
]

const orthogonal_directions = [
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
]
#endregion

const PROCESSOR_CENTER = Vector2(-0.5, -0.5)
const CHIP_SIZE = Vector2(32, 32)

const CIRCUIT_WIDTH: float = 8
const circuit_indexs = [
	2,3,9,10,16,17,23,22,28,27,33,32,26,25,19,18,12,13,7,8
]
