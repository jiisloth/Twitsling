extends Control


export(PackedScene) var PlayerRow

func _ready():
    Global.connect("score_updated", self, "on_update")
    Global.connect("score_reset", self, "on_reset")
    on_update()

var players = {}
var row_height = 10


func on_update():
    var i = 0
    for player in Global.players:
        if not player["id"] in players.keys():
            add_player(player, i)
        else:
            var prow = players[player["id"]]
            prow.set_values(i, player["nick"], player["score"])
            $Tween.interpolate_property(prow, "margin_top", prow.margin_top, i * row_height, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
            $Tween.start()
        i += 1


func on_reset():
    for prowi in players.keys():
        players[prowi].queue_free()
        
    players = {} 
    
            
func add_player(player, i):
    var prow = PlayerRow.instance()
    prow.set_values(i, player["nick"], player["score"])
    prow.margin_top = i * row_height
    prow.anchor_right = 0
    add_child(prow)
    players[i] = prow
    $Tween.interpolate_property(prow, "anchor_right", 0, 1, 0.5,Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()
    
