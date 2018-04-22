extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene;
var TILE_SIZE = 32;

var grid = [];
var binaryGrid = [];

var miners = [];
var regions = [];
var regionTotals = [];
var distanceBFS = [];

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

func findFirstEmptySpace():
    for i in range(0,len(regions)):
        for j in range(0,len(regions[0])):
            if regions[i][j] == -1:
                return([i,j]);
    return null;
    
func checkSurroundings(matrix, index):
    #print(index);
    var possible = [[index[0]+1, index[1]], [index[0]-1, index[1]], [index[0], index[1]+1], [index[0], index[1]-1]];
    var ret = [];
    for val in possible:
        #if(matrix==distanceBFS):
        #    print(val, " -- ", matrix[val[0]][val[1]]);
        if val[0]>0 and val[0]<WIDTH-1 and val[1]>0 and val[1]<HEIGHT-1 and matrix[val[0]][val[1]] == -1:
            ret.append(val);
    return ret;
    
    
func fillingBFS(index, fillVal):
    regions[index[0]][index[1]] = fillVal;
    var delta = [index];
    var total = 0;
    while len(delta) > 0:
        total+=1;
        #print(delta);
        var target = delta[0];
        delta.remove(0);
        #print(delta);
        var openNeighbors = checkSurroundings(regions, target);
        for space in openNeighbors:
            regions[space[0]][space[1]] = fillVal;
            #print("Appended", space);
            delta.append(space);
    #print("Starting from:", index, "filled", total);
    return total;
            
func findBiggestRegion():
    regions = [];
    regionTotals = [];
    for col in binaryGrid:
        var newCol = [];
        for val in col:
            if val == 1:
                newCol.append(-2);
            if val == 0:
                newCol.append(-1);
        regions.append(newCol);
        
    var fillVal = 0;
    while findFirstEmptySpace() != null:
        var index = findFirstEmptySpace();
        regionTotals.append(fillingBFS(index, fillVal));
        fillVal+=1;
        
    #print("Totals:", regionTotals);
        
    var maxRegionTotal = -1;
    var maxIndex = -1;
    for i in range(0, len(regionTotals)):
        if i==0 or regionTotals[i] > maxRegionTotal:
            maxIndex = i;
            maxRegionTotal = regionTotals[i];
    return maxIndex;
    
    
func pickRandomPositionInRegion(regionLabel):
    var positions = [];
    for i in range(0,WIDTH):
        for j in range(0,HEIGHT):
            if regions[i][j] == regionLabel:
                positions.append([i,j]);
    #print("Positions array length:", len(positions));
    return(positions[randi()%len(positions)]);
        
func calculateDistances(regionLabel, startPoint):
    var delta = [startPoint];
    distanceBFS = [];
    
    for i in range(0,WIDTH):
        var row = [];
        for j in range(0,HEIGHT):
            if regions[i][j] != regionLabel:
                row.append(-2);
            else:
                row.append(-1);
        distanceBFS.append(row);
            
    distanceBFS[startPoint[0]][startPoint[1]] = 0;
    var maxDistance = -1;
    var valueSum = 0;
    var valueCount = 0;
    while len(delta) > 0:
        #print(len(delta));
        var target = delta[0];
        delta.remove(0);
        #print(delta);
        var openNeighbors = checkSurroundings(distanceBFS, target);
        #print("Open Neighbors length:", len(openNeighbors));
        var fillVal = distanceBFS[target[0]][target[1]]+1;
        for space in openNeighbors:
            distanceBFS[space[0]][space[1]] = fillVal;
            #print("Appended", space);
            valueSum += fillVal;
            valueCount += 1;
            if(fillVal > maxDistance):
                maxDistance = fillVal;  
            delta.append(space);
    #print("Average distance from location: ", valueSum/valueCount, " -- Max distance: ", maxDistance);
    #for col in distanceBFS:
    #    print(col);

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    randomize();

    for i in range(0, WIDTH):
        var row = [];
        for j in range(0,HEIGHT):
            row.append(1);
        binaryGrid.append(row);
    #print(binaryGrid);
    miners = [];
    mineGrid();
    var regionLabel = findBiggestRegion();
    var randomIndex = pickRandomPositionInRegion(regionLabel);
    #print("Random Index in region:", regionLabel, "is", randomIndex);
    calculateDistances(regionLabel, randomIndex);
    var player = get_parent().find_node("PlayerRoot").find_node("PlayerKinematicBody");
    player.position = Vector2(randomIndex[0] * TILE_SIZE, randomIndex[1] * TILE_SIZE);
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
