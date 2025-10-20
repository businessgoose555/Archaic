extends CharacterBody2D

var speed = 70
var player_chase = true
@onready var player = get_parent().get_node("player")

var sword_inattack_range = false
var sword_attack_cooldown = true
var fireball_inattack_range = false
var fireball_attack_cooldown = true
var enemy_health = 1
var enemy_alive = true
@onready var healthbar: ProgressBar = $healthbar

func small_enemy():
	pass

func _physics_process(delta: float) -> void:
	fireball_attack()
	sword_attack()
	if player_chase and is_instance_valid(player):
		var direction = (player.position - position).normalized()
		velocity = (direction*speed)
		
		$AnimatedSprite2D.play("Run")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	move_and_slide()


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("sword"):
		sword_inattack_range = true
	if body.has_method("fireball"):
		fireball_inattack_range= true
	print ("enemy is hit")

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("sword"):
		sword_inattack_range = false
	if body.has_method("fireball"):
		fireball_inattack_range = false

func sword_attack():
	if sword_inattack_range: 
		enemy_health = enemy_health - 10
		sword_attack_cooldown = false
		$attack_cooldown.start()
		healthbar.value = enemy_health
		print (enemy_health)
		if enemy_health <= 0:
			self.queue_free()

func fireball_attack(): 
	if fireball_inattack_range: 
		enemy_health = enemy_health - 2
		fireball_attack_cooldown = false
		$attack_cooldown.start()
		print (enemy_health)
		if enemy_health <= 0:
			self.queue_free()

func _on_attack_cooldown_timeout() -> void:
	fireball_attack_cooldown = true
	sword_attack_cooldown = true
