extends KinematicBody2D


var velocity = Vector2(0,0)
var walk = true

var walk_jump = 0
const gravity = 12
const jump = -230

var jump_particles = preload("res://scene/jump_particles.tscn")

var dropper = true
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if Input.is_action_pressed("D") and walk:
		velocity.x = 100
		$sprite.flip_h = false
	if Input.is_action_pressed("A") and walk:
		velocity.x = -100
		$sprite.flip_h = true

	if is_on_wall() and !is_on_floor() and velocity.y>0 and velocity.y<400:
		velocity.y = gravity*4 #gravity on wall
		$sprite.frame = 1
		if Input.is_action_just_pressed("W") and walk_jump <6:#jump in wall
			velocity.y = jump
			walk_jump +=1
			walk = true
			$sprite.frame = 4
			var particles = jump_particles.instance()
			particles.position = global_position
			particles.position.y += 2
			particles.position.x += velocity.x/40
			particles.emission_rect_extents = Vector2(2,4)
			particles.one_shot = true
			
			$particles.emitting = true
			get_parent().add_child(particles)
			if $sprite.flip_h:
				velocity.x = +71
			else:
				velocity.x = -71
			$sprite.flip_h = !$sprite.flip_h
			walk = false
	else:
		velocity.y = velocity.y+gravity #regular gravity
	 
	if (velocity.x > 10 or velocity.x < -10)  and is_on_floor() and !is_on_wall():
		$anim.play("run")
		walk_jump = 0
		walk = true
	else:
		$anim.stop()
		if is_on_floor():
			$sprite.frame = 0
			walk_jump = 0
			walk = true
		elif !is_on_wall() and velocity.y >80:
			$sprite.frame = 6
			dropper = true
			
			
			
	if Input.is_action_just_pressed("W") and is_on_floor():#jump
		velocity.y = jump
		$sprite.frame = 4
		var particles = jump_particles.instance()
		particles.position = global_position
		particles.position.y += 4
		particles.one_shot = true
		
		
		get_parent().add_child(particles)
		$particles.emitting = true
	velocity = move_and_slide(velocity,Vector2.UP)
	if walk:velocity.x = lerp(velocity.x,0,0.4) #diminuindo vel
	else:
		velocity.x = lerp(velocity.x,0,0.04)
		if velocity.y > 90:
			walk = true
	if velocity.y > -90 :
		$particles.emitting = false
	if dropper and is_on_floor():
		var particles = jump_particles.instance()
		particles.position = global_position
		particles.amount = 3
		particles.position.y += 4
		particles.one_shot = true
		
		get_parent().add_child(particles)
		dropper = false
	#print(velocity.y)



func _on_Area2D_body_entered(body):
	#print(velocity.y )
	var vel = velocity.y
	if body.has_method("_explode") and velocity.y > vel:
		body._explode()
	pass # Replace with function body.
