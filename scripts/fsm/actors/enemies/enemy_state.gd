class_name EnemyState extends State

@onready var body: Actor = get_owner()
@onready var animator: AnimationPlayer = body.get_node("animator")
