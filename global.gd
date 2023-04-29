extends Node


var players = []

var paused = true

signal score_updated

class MyCustomSorter:
    static func sort(a, b):
        if a["score"] > b["score"]:
            return true
        return false

func check_active(nick):
    for p in players:
        if nick == p["nick"]:
            return p["active"]
    return false


func set_active(nick):
    for p in players:
        if nick == p["nick"]:
            p["active"] = true
            return
    players.append({"nick": nick, "score": 0, "id": len(players), "active": true})
    emit_signal("score_updated")


func set_inactive(nick):
    for p in players:
        if nick == p["nick"]:
            p["active"] = false
            return
    players.append({"nick": nick, "score": 0, "id": len(players), "active": false})
    

func add_score(nick, score):
    var player = false
    var i = 0
    for p in players:
        i += 1
        if nick == p["nick"]:
            p["score"] += score
            player = true
            break
    if not player:
        players.append({"nick": nick, "score": score, "id": len(players), "active": true})
    sort_players()
    emit_signal("score_updated")


func sort_players():
    players.sort_custom(MyCustomSorter, "sort")
