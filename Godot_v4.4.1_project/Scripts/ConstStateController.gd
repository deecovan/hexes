extends Node

const BEGIN_TURN = 10
const DRAW_HEX = 20
const END_TURN = 99
var states = [BEGIN_TURN, DRAW_HEX, END_TURN]

const PLAYER = 1000
const OPPONENT = 5000
var owners = [PLAYER, OPPONENT]

var turn_sequence = []
var current_stage = 0

func _ready() -> void:
	for own in owners:
		for stt in states:
			turn_sequence.append(own + stt)
	## Test output
	prints("Turn sequence:", turn_sequence)
	prints("Random  stage:", get_stage_data(randi_range(-10,10)))
	prints("Current stage:", get_stage_data(current_stage))
	prints("Prev.   stage:", get_stage_data(current_stage-1))
	prints("Next    stage:", get_stage_data(current_stage+1))
	## Start Turn Sequence from current_stage: 
	#- ...Start Turn Sequence from current_stage: 
	  #- PLAYER BEGIN_TURN
	  #- Pass to DRAW_HEX
	#- ...Add principal Draw
	  #- Deck in TablePart 2
	  #- Draw a Hex on Draw Stage 
	
func get_stage_data(stage: int) -> Dictionary:
	print("get_stage_data(stage=" + str(stage) + ")")
	## Prevent Array Out of index error
	while stage < 0:
		stage += turn_sequence.size()
	while stage > turn_sequence.size() - 1:
		stage -= turn_sequence.size()
	return {
		"Owner": get_turn_owner(turn_sequence[stage]),
		"Phase": get_turn_state(turn_sequence[stage]),
	}

func get_turn_owner(stage: int) -> int:
	if stage >= OPPONENT:
		return OPPONENT
	else: 
		return PLAYER

func get_turn_state(stage: int) -> int:
	while stage >= PLAYER:
		stage -= PLAYER
	return stage
