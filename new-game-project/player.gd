extends CharacterBody2D

@export var tilemap: TileMapLayer
@export var tile_offset: Vector2 = Vector2.ZERO   # how far from tile center the player stands

var cell: Vector2i

func _ready() -> void:
	# Treat the *tile center* as global_position - offset
	cell = tilemap.local_to_map(global_position - tile_offset)
	global_position = tilemap.map_to_local(cell) + tile_offset


func _physics_process(delta: float) -> void:
	var input := Vector2i.ZERO

	if Input.is_action_just_pressed("ui_right"):
		input.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	elif Input.is_action_just_pressed("ui_down"):
		input.y += 1
	elif Input.is_action_just_pressed("ui_up"):
		input.y -= 1

	if input == Vector2i.ZERO:
		return

	var target_cell := cell + input

	if not _cell_walkable(target_cell):
		return

	cell = target_cell
	global_position = tilemap.map_to_local(cell) + tile_offset


func _cell_walkable(c: Vector2i) -> bool:
	return tilemap.get_cell_source_id(c) != -1
