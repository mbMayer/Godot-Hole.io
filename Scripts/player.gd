extends CharacterBody3D

@export var speed:int = 5

var hole = preload("res://Scenes/Hole.tscn").instantiate()
var start_hole_radius = hole.radius

var collected: int = 0

func _ready():
	#for CSGCombiner work properly, to substract floor(CSGBox)
	await get_parent().ready
	get_parent().add_child(hole) 
	
func _physics_process(delta):
	var velocity = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity += global_transform.basis.z
	if Input.is_action_pressed("ui_down"):
		velocity -= global_transform.basis.z
	if Input.is_action_pressed("ui_left"):
		velocity += global_transform.basis.x
	if Input.is_action_pressed("ui_right"):
		velocity -= global_transform.basis.x
	set_velocity(velocity * speed)
	move_and_slide()
	#sync hole and player position
	hole.global_transform.origin = global_transform.origin


func set_hole_size(size:float):
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "scale", Vector3.ONE * size, 2)
	tween.parallel().tween_property(hole, "radius", start_hole_radius * size, 2)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.apply_central_impulse(Vector3.DOWN)

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		collected += 1
		print(collected)
		body.queue_free()
		if collected > 5:
			set_hole_size(2)
