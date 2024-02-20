extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	# check if we have touched the player by checking if the body has a IsPlayer node
	if body.get_node("IsPlayer"):
		# add to the colected stars list
		owner.called_deferred(self)
		var stars = body.get_node("stars")
		stars.add_child(self)
