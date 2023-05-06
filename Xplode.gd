extends Area2D

var sender = ""
var bigboom = true

func _on_Xplode_body_entered(body):
    var score = 5 + randi()%10 + randi()%10
    if body.is_in_group("XplodePeg") or body.is_in_group("BombPeg"):
        if body.exploded == false:
            if body.global_position == global_position:
                return
            get_parent().call_deferred("create_explosion",body.global_position, sender)
            score *= 2
            body.exploded = true
    
    if body.is_in_group("BadPeg"):
        score = -score
        
    if body.is_in_group("RewindPeg"):
        get_parent().call_deferred("rewind")
        score *= 2
    
    
    if body.is_in_group("RemovePeg"):
        get_parent().create_scorepop(body.global_position, score)
        Global.add_score(sender, score)
        body.queue_free()
    
    if bigboom and body.is_in_group("HardPeg"):
        get_parent().create_scorepop(body.global_position, score)
        Global.add_score(sender, score)
        body.queue_free()

        
    if body.is_in_group("Stone"):
        var impulse = body.global_position - global_position
        body.apply_central_impulse(impulse*50)


func _on_Timer_timeout():
    get_node("CollisionShape2D").disabled = true


func _on_AnimatedSprite_animation_finished():
    queue_free()
