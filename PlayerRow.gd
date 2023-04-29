extends Control


func set_values(rank, nick, score):
    $Rank.text = str(rank+1) + "."
    $Nick.text = str(nick)
    $Score.text = str(score) + "p"
