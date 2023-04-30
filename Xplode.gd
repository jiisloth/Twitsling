extends Area2D


export(PackedScene) var Xplode
export(PackedScene) var ScorePop

var sender = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func create_explosion(body):
    var xplosion = Xplode.instance()
    xplosion.global_position = body.global_position
    xplosion.sender = sender
    get_parent().add_child(xplosion)
    
func create_scorepop(body, score):
    var scorepop = ScorePop.instance()
    scorepop.global_position = body.global_position
    scorepop.txt = str(score) + "p"
    get_parent().add_child(scorepop)

func _on_Xplode_body_entered(body):
    var score = 5 + randi()%10 + randi()%10
    if body.is_in_group("XplodePeg") or body.is_in_group("BombPeg"):
        if body.global_position == global_position:
            return
        # create_explosion(body)
        score *= 2
    
    if body.is_in_group("BadPeg"):
        score = -score
        
    if body.is_in_group("RewindPeg"):
        get_parent().call_deferred("rewind")
        score *= 2
    
    
    if body.is_in_group("RemovePeg"):
        # create_scorepop(body, score)
        Global.add_score(sender, score)
        
        body.queue_free()

        
    if body.is_in_group("Stone"):
        var impulse = body.global_position - global_position
        body.apply_central_impulse(impulse*50)


func _on_Timer_timeout():
    queue_free()
