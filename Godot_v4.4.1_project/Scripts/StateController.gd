extends Node

enum Owners {
	User,
	Opponent
}
enum TurnStates {
	BeginTurn,
	DrawHex,
	EndTurn
}
enum GameStates {
	Starting = 0,
	Playing,
	Ending,
	Finished
}
var turn_sequence = []
var current_state = GameStates.Starting
var tests_finished = false

func _ready() -> void:
	## Init Turn sequence
	for own in Owners:
		for tst in TurnStates:
			turn_sequence.append([own, tst])
	runTests(turn_sequence, false)
	
func emitNextGameState() -> void:
	match current_state:
		GameStates.Starting:
			print_rich("switch [color=green]Playing")
			## Emit Next Game State
			current_state = GameStates.Playing
		GameStates.Playing:
			print_rich("switch [color=yellow]Ending")
			## Emit Next Game State
			current_state = GameStates.Ending
		GameStates.Ending:
			print_rich("switch [color=red]Finished")
			## Emit Next Game State
			current_state = GameStates.Finished
	
func getStateData(state: int) -> Dictionary:
	print("getStateData(state=" + str(state) + ")")
	## Prevent Array Out of index error
	while state < 0:
		state += turn_sequence.size()
	while state > turn_sequence.size() - 1:
		state -= turn_sequence.size()
	return {
		"Owner": turn_sequence[state][0],
		"State": turn_sequence[state][1],
	}

func runTests(_message, _print = false, _force = false) -> void:
	if tests_finished and not _force:
		return
	## Test output
	if _print:
		prints("_______________|Tests for", self.name)
		prints(_message)
		prints("Random  state:", getStateData(randi_range(-10,10)))
		prints("Current state:", getStateData(current_state))
		prints("Prev.   state:", getStateData(current_state-1))
		prints("Next    state:", getStateData(current_state+1))
	tests_finished = true
