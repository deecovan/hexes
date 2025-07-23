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
	run_tests(turn_sequence, false)
	
func next_game_state() -> void:
	match current_state:
		GameStates.Starting:
			print_rich("[color=green]GameStates.Playing")
			current_state = GameStates.Playing
		GameStates.Playing:
			print_rich("[color=green]GameStates.Ending")
			current_state = GameStates.Ending
		GameStates.Ending:
			print_rich("[color=red]GameStates.Ending")
			current_state = GameStates.Finished
	
func get_state_data(state: int) -> Dictionary:
	print("get_state_data(state=" + str(state) + ")")
	## Prevent Array Out of index error
	while state < 0:
		state += turn_sequence.size()
	while state > turn_sequence.size() - 1:
		state -= turn_sequence.size()
	return {
		"Owner": turn_sequence[state][0],
		"State": turn_sequence[state][1],
	}

func run_tests(_message, _print = false, _force = false) -> void:
	if tests_finished and not _force:
		return
	## Test output
	if _print:
		prints("_______________|Tests for", self.name)
		prints(_message)
		prints("Random  state:", get_state_data(randi_range(-10,10)))
		prints("Current state:", get_state_data(current_state))
		prints("Prev.   state:", get_state_data(current_state-1))
		prints("Next    state:", get_state_data(current_state+1))
	tests_finished = true
