class_name Projectile
extends CharacterBody2D


var type
var weapon_range
var speed
var strength
var target
var firing_position
var fired = false
@onready var explosion = $Explosion
#signal hit

func _ready():
	explosion.visible = false

func _process(delta):
	if fired == true:
		velocity = firing_position.direction_to(target.position) * speed 
		var collision = move_and_collide(velocity * delta)
		if collision != null:
			fired = false
			# hack
			explosion.visible = true
			await get_tree().create_timer(.3).timeout
			explosion.visible = false
			# /hack
			if is_instance_valid(collision.get_collider()): # this check probably should be replaced by something better
				collision.get_collider().hit(strength)
			queue_free()
