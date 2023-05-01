extends RigidBody2D


var hits = 1

var sender = ""
var init_p = 90 - randf()*180
var init_d = randf() *100

var rng = RandomNumberGenerator.new()

func _ready():
    $Label.text = sender.left(3)
    apply_central_impulse(Vector2(1+init_p*5,0).rotated(deg2rad(init_d)))
    apply_torque_impulse(init_d*100)
    set_colors()


func set_colors():
    rng.seed = hash(sender)
    if rng.randf() < 0.5:
        $Stone/Color1.modulate.v = 0.9 + rng.randf()*0.1
        $Stone/Color1.modulate.s = 1
    else:
        $Stone/Color1.modulate.s = 0.8 + rng.randf()*0.2
        $Stone/Color1.modulate.v = 1
    $Stone/Color1.modulate.h = rng.randf()
    if rng.randf() < 0.5:
        $Stone/Color2.modulate.v = 0.9 + rng.randf()*0.1
        $Stone/Color2.modulate.s = 1
    else:
        $Stone/Color2.modulate.s = 0.8 + rng.randf()*0.2
        $Stone/Color2.modulate.v = 1
    $Stone/Color2.modulate.h = rng.randf()
    $Stone.rotation = randf()*2*PI
    

func _on_Stone_body_entered(body):
    var score = 5 # + randi()%10 + randi()%(5*hits)
    if body.is_in_group("XplodePeg"):
        get_parent().call_deferred("create_explosion",body.global_position, sender)
        score *= 2
    if body.is_in_group("BouncePeg"):
        var impulse = global_position - body.global_position
        call_deferred("apply_central_impulse",impulse * 20)

    if body.is_in_group("BombPeg"):
        get_parent().call_deferred("create_pegxplode",body.global_position)

    
    if body.is_in_group("BadPeg"):
        score = -score
        
    if body.is_in_group("RewindPeg"):
        get_parent().call_deferred("rewind")
        score *= 2
    
    
    if body.is_in_group("RemovePeg"):
        get_parent().create_scorepop(body.global_position, score)
        Global.add_score(sender, score)
        hits += 1
        
        body.queue_free()

