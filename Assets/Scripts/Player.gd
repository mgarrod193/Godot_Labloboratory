extends CharacterBody2D

signal killed
var dead = false

const SPEED = 125.0
const JUMP_VELOCITY = -450.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var push_force : float = 80

func _physics_process(delta):
	if not dead:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
	
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
func die():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	dead = true
