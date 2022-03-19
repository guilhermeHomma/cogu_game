extends KinematicBody2D


var velocity = Vector2(0,0)
var forca_velocidade = 100
var walk = true

var walk_jump = 0
const gravity = 12
const jump = -230

var jump_particles = preload("res://scene/jump_particles.tscn")
var dropper = true


func _ready():

	if !is_network_master():

		$camera.current = false
		$sprite.modulate.a = 0.6
		z_index = -1
		$coll.disabled = true
		
	pass # Replace with function body.

func _physics_process(_delta) -> void:
	if is_network_master():
		if Input.is_action_pressed("D") and walk:
			velocity.x = forca_velocidade
			$sprite.flip_h = false
		if Input.is_action_pressed("A") and walk:
			velocity.x = -forca_velocidade ##ou troca aq por 100
			$sprite.flip_h = true

		if is_on_wall() and !is_on_floor() and velocity.y>0 and velocity.y<400:
			velocity.y = gravity*4 #gravity on wall
			$sprite.frame = 1
			forca_velocidade = 30
			if Input.is_action_just_pressed("W") and walk_jump <6:#jump in wall
				velocity.y = jump
				walk_jump +=1
				##walk = true
				$sprite.frame = 4
				rpc_unreliable("Particulas_",4,5,global_position.x+velocity.x/50,global_position.y+2,Vector3(2,4,0))
				$particles.emitting = true
				
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
			forca_velocidade = 100
		else:
			$anim.stop()
			if is_on_floor():
				$sprite.frame = 0
				walk_jump = 0
				walk = true
				forca_velocidade = 100
			elif !is_on_wall() and velocity.y >80:
				$sprite.frame = 6
				dropper = true
				if forca_velocidade >= 10:
					forca_velocidade = lerp(forca_velocidade,10,_delta)
					
					
		if Input.is_action_just_pressed("W") and is_on_floor():#jump
			velocity.y = jump
			$sprite.frame = 4
			#Particulas_(10,4,global_position.x,global_position.y+5,Vector3(5,2,1))
			rpc_unreliable("Particulas_",10,4,global_position.x,global_position.y+5,Vector3(5,2,1))
			$particles.emitting = true
			
		velocity = move_and_slide(velocity,Vector2.UP)
		if walk:
			velocity.x = lerp(velocity.x,0,0.4) #diminuindo vel
		else:
			velocity.x = lerp(velocity.x,0,0.04)
			if velocity.y > 90:
				walk = true
				forca_velocidade = 100
		if velocity.y > -90 :
			$particles.emitting = false
		if dropper and is_on_floor():
			#Particulas_(3,2,global_position.x,global_position.y+5.6,Vector3(3,1,1))
			rpc_unreliable("Particulas_",3,2,global_position.x,global_position.y+5.6,Vector3(3,1,1))
			dropper = false

		if position.y >= 10:
			_dead()
		rpc("Atualizar_tudo",position,$sprite.flip_h,$particles.emitting,$sprite.frame)
	#if !is_network_master():
		#$camera.current = false

remote func Atualizar_tudo(pos,flip,part,frame):
	position = pos
	$sprite.flip_h = flip
	$particles.emitting = part
	$sprite.frame = frame
	
func _dead():
	position = Vector2(-200,-480)
	velocity.y = 0

remotesync func Particulas_(amount_,scale_,posx_,posy_,shape_):
	var particles = jump_particles.instance()
	particles.amount = amount_
	particles.process_material.scale = scale_
	particles.position.y += posy_
	particles.position.x += posx_
	particles.process_material.emission_box_extents = shape_
	particles.modulate.a = $sprite.modulate.a
	get_parent().add_child(particles)
	pass

