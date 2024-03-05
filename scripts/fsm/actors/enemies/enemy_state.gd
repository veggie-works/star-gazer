## Base state for enemies
class_name EnemyState extends State

## The root character body of the FSM
@onready var body: Actor = get_owner()
## Controls animations for the enemy
@onready var animator: AnimationPlayer = body.get_node("animator")
