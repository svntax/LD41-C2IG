extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene;
var TILE_SIZE = 32;

var grid = [];

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var WIDTH = 5;
	var HEIGHT = 3;
	scene = load("res://Scenes/wall.tscn")
	for i in range(0, WIDTH):
		var row = [];
		for j in range(0,HEIGHT):
			
			var block = scene.instance()	
			block.position = Vector2(i*TILE_SIZE, j*TILE_SIZE)
			add_child(block)
			row.append(block);
		grid.append(row);

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
