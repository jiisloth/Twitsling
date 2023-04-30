extends Node2D

export(PackedScene) var Peg
export(PackedScene) var PegNormal
export(PackedScene) var PegSticky
export(PackedScene) var PegRewind
export(PackedScene) var PegBomb
export(PackedScene) var PegXplode
export(PackedScene) var PegBad
export(PackedScene) var Stone
export(PackedScene) var Xplode
export(PackedScene) var ScorePop

var lvl
var launchpos

var lvlindex = 0

func _ready():
    $Levels.hide()
    launchpos = $BG/Viuhti/Launchpos.global_position
    lvl = $Levels.get_child(lvlindex)
    set_pegs()

func set_level(add):
    lvlindex += add
    if lvlindex < 0:
        lvlindex = $Levels.get_child_count()-1
    if lvlindex >= $Levels.get_child_count():
        lvlindex = 0
    lvl = $Levels.get_child(lvlindex)
    set_pegs()

  
func rewind():
    set_pegs(false)
    
func set_pegs(initial=true):
    if initial:
        $Hodl.clear()
        var stones = get_tree().get_nodes_in_group("Stone")
        for stone in stones:
            Global.set_inactive(stone.sender)
            stone.queue_free()
        var pegs = get_tree().get_nodes_in_group("Peg")
        for peg in pegs:
            peg.queue_free()
            
    var tiles = lvl.get_used_cells()
    for coord in tiles:
        var cell = lvl.get_cell(coord.x, coord.y)
        add_peg(coord, cell, initial)
        if initial:
            $Hodl.set_cell(coord.x, coord.y, 2)
    if initial:
        lvl.hide()
        

func add_peg(coord, variant, initial):
    var pegpos = coord * 8 * 2 + Vector2(16,16)
    if not initial:
        var stones = get_tree().get_nodes_in_group("Stone")
        for stone in stones:
            if (stone.position - pegpos).length() < 32:
                return
        var pegs = get_tree().get_nodes_in_group("Peg")
        for peg in pegs:
            if (peg.position - pegpos).length() < 5:
                return
    var peg
    match variant:
        0:
            return
        1:
            peg = Peg.instance()
        2:
            var r = randi()%20
            peg = PegNormal.instance()
            match r:
                0:
                    peg = PegSticky.instance()
                1:
                    peg = PegRewind.instance()
                2:
                    peg = PegBomb.instance()
        3:
            peg = PegNormal.instance()
        4:
            peg = PegSticky.instance()
        5:
            peg = PegRewind.instance()
        6:
            peg = PegBomb.instance()
        7:
            peg = PegXplode.instance()
        8:
            peg = PegBad.instance()
        
    peg.position = pegpos
    add_child(peg)
    

func shoot(sender, dir, power):
    var stone = Stone.instance()
    stone.sender = sender
    stone.global_position = launchpos
    stone.init_d = dir
    stone.init_p = power
    add_child(stone)


func _on_KillZone_body_entered(body):
    if body.is_in_group("Stone"):
        Global.set_inactive(body.sender)
        body.queue_free()


func create_explosion(pos, sender):
    var xplosion = Xplode.instance()
    xplosion.global_position = pos
    xplosion.sender = sender
    add_child(xplosion)
    
    
func create_pegxplode(pos):
    var pegxplosion = PegXplode.instance()
    pegxplosion.global_position = pos
    add_child(pegxplosion)
    
    
func create_scorepop(pos, score):
    var scorepop = ScorePop.instance()
    scorepop.global_position = pos
    scorepop.txt = str(score) + "p"
    add_child(scorepop)
