extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene;
var TILE_SIZE = 32;

var grid = [];
var binaryGrid = [];

var miners = [];

var WIDTH = 50;
var HEIGHT = 50;

class Miner:
    var x=0;
    var y=0;
    var boundX = 0;
    var boundY = 0;
    func _init(x,y, boundX, boundY):
        self.x = x;
        self.y = y;
        self.boundX = boundX;
        self.boundY = boundY;
        
    func moveMiner():
        var choice = randi()%4 + 1; 
        
        if choice == 1:
            self.y-=1;
        elif choice == 2:
            self.x+=1;
        elif choice == 3:
            self.y+=1;
        elif choice == 4:
            self.x-=1;
                
        self.x = abs(int(self.x) % int(self.boundX));
        self.y = abs(int(self.y) % int(self.boundY));
        
func mineGrid():
    var maxSteps = 500;
    var spawnChance = 10;
    var miner1 = Miner.new(floor(len(binaryGrid)/2), floor(len(binaryGrid[0])/2), len(binaryGrid), len(binaryGrid[0]));
    miners.append(miner1);
    for i in range(0, maxSteps):
        if randi()%100+1 < spawnChance:
            miners.append(Miner.new( randi()%(WIDTH-1)+1, randi()%(HEIGHT-1)+1, WIDTH, HEIGHT));
        var j = 0;
        while(j < len(miners)):
            var miner = miners[j];
            miner.moveMiner();
            if miner.x == 0 or miner.y == 0 or miner.x == len(binaryGrid) - 1 or miner.y == len(binaryGrid[0]) - 1:
                miners.remove(j);
            else:
                j+=1;
                if binaryGrid[miner.x][miner.y] == 1:
                    binaryGrid[miner.x][miner.y] = 0;
            
        


func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    

    for i in range(0, WIDTH):
        var row = [];
        for j in range(0,HEIGHT):
            row.append(1);
        binaryGrid.append(row);
    #print(binaryGrid);
    miners = [];
    mineGrid();
    
    #for col in binaryGrid:
    #    print(col);
    
    scene = load("res://Scenes/wall.tscn")
    for i in range(0, WIDTH):
        var row = [];
        for j in range(0,HEIGHT):
            if binaryGrid[i][j] == 1:
                var block = scene.instance()
                block.position = Vector2(i*TILE_SIZE, j*TILE_SIZE)
                add_child(block)
                row.append(block);
        grid.append(row);

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
