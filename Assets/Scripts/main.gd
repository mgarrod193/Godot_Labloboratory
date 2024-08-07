extends Node

var game_over : bool #game status variable
var score : int #Player's score
var max_score : int

var collectables

# Called when the node enters the scene tree for the first time.
func _ready():
	$Level_end_scene.hide()
	game_over = false
	$Player.position = $StartingPosition.position #sets player position
	$Level_end_scene.max_score = $Collectables.get_child_count()
	score = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_over:
		$Hud.show()

#Triggers game over
func _on_player_killed():
	game_over = true
	$GUI.hide()

#Triggers game resatart
#Calls restart in player, lasers, switches and collectables
func _on_restart():
	game_over = false
	score = 0
	$Player.restart()
	get_tree().call_group("Lasers", "restart")
	get_tree().call_group("switches", "restart")
	$Collectables.get_tree().call_group("Collectable", "restart")
	get_tree().call_group("saws", "restart")
	$GUI.show()
	$GUI.update_score(score)
	$Hud.hide()


func end_level():
	$Level_end_scene.show()
	$Level_end_scene.calculate_level_score(score)
	$Player.can_move = false



func _on_player_collected():
	score += 1
	$GUI.update_score(score)
