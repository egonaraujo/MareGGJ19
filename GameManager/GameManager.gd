extends Node2D

enum ECONT {
	NONE,
	MAT,
	WALL,
	WATER
}
var lastAction = ECONT.NONE
var targetAction = Vector2(-1, -1)
export (Vector2) var offset = Vector2(0,0)
export (PackedScene) var Wave

var timelapse = 0
var nextTime = 0
export (float) var minTime = 0
export (int) var timeOffset = 0
var maxTime
export (PackedScene) var Leaderboard
var score =0
var nextWaveSide = 1
var dead =false

func _ready():
	position = position + offset
	randomize()
	score=0
	$map.listener(self)
	var playerInit = Vector2(10, 8)
	$Player.setpos(playerInit)
	$map.setBusy(playerInit)
	#$map.setupMaterials()
	$map.setFree(playerInit)
	$Player.connect("endMoviment", self, "doAction")
	nextTime = 0
	set_process(true)
	maxTime = minTime + timeOffset

func _process(delta):
	timelapse += delta
	if timelapse > nextTime:
		var wave = Wave.instance()
		wave.position.x = 224
		add_child(wave)
		wave.connect("waveCover", self, "onWave")
		wave.connect("waveAfter", self, "afterWave")
		set_process(false)
		$Player.set_process(false)
		$map.set_process(false)
		
	# Down wave
	var perc = timelapse/maxTime
	$waveHud.position.y = perc*192 + (maxTime - nextTime)*16

func onWave():

	if !$map.wave(nextWaveSide,1) && !dead:
		dead=true
		set_process(false)
		var lb = Leaderboard.instance()
		lb.rect_scale = Vector2(0.5,0.5)
		lb.rect_position = Vector2(-32,0)
		lb.receiveScore(score)
		self.add_child(lb)
		$map.set_process(false)
		$Player.set_process(false)
		return
	setBallon(nextWaveSide, false, 1)
	nextWaveSide = (randi()%4)+1
	timelapse = 0
	nextTime = (randi()%(timeOffset)) + minTime
	
	score= score+1
	$scoreLabel.set_text("Score: " + str(score))
	
func afterWave():
	set_process(true)
	$Player.set_process(true)
	$map.set_process(true)
	setBallon(nextWaveSide, true, 1)

func spawnWave():
	var direction = (randi()%5)+1
	score +=1
	emit_signal("waveSpawned",direction)

func detectTouch(indexes, contType):
	lastAction = contType
	targetAction = indexes;
	$Player.setMove($map.move($Player.gridPos,indexes))

func doAction():
	if lastAction == ECONT.MAT:
		$Player.inventory  = $map.collect(targetAction)
	elif lastAction == ECONT.WALL || lastAction == ECONT.NONE:
		if $map.build(targetAction, $Player.inventory):
			$Player.inventory = -1
	$inventory.put($Player.inventory)
	pass

func setBallon(ballon, active, dmg):
	var inc = ballon if active else 0
	if ballon == 1:
		$up.makeVisible(inc, dmg)
	elif ballon == 2:
		$right.makeVisible(inc, dmg)
	elif ballon == 3:
		$down.makeVisible(inc, dmg)
	elif ballon == 4:
		$left.makeVisible(inc, dmg)

