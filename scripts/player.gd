extends CharacterBody2D

@export var speed = 250
@export var acceleration = 0.08
@export var friction = 0.2 #replace later with one fram the map once
var current_dir = "none"

@export var  action_attack_one: = "attack_one"
@export var  action_attack_two: = "attack_two"
@export var  action_dash: = "attack_dash"

@export var  attack1_duration: = 0.55
@export var  attack2_duration: = 0.35
@export var  attack1_cooldown: = 0.3
@export var  attack2_cooldown: = 0.45

@export var dash_speed_multiplier = 1.75   
@export var dash_duration  = 0.20         
@export var dash_cooldown = 2
var last_move_dir := Vector2.RIGHT

@onready var healthbar: ProgressBar = $healthbar
var health = 100
var player_alive = true
var small_enemy_inattack_range = false
var enemy_attack_cooldown = true
var is_attacking: = false
var is_dashing: = false
var can_dash: = true
var attack1_on_cooldown: = false
var attack2_on_cooldown: = false
var dash_velocity: Vector2 = Vector2.ZERO

@onready var rectbottom: CollisionShape2D = $sword_1/rectbottom
@onready var recttop: CollisionShape2D = $sword_1/recttop

@onready var circle_2: CollisionShape2D = $sword_2/circle2
@onready var rect_2: CollisionShape2D = $sword_2/rect2

func player():
	pass
const gameover_scene:PackedScene = preload("res://scenes/gameover.tscn")
var gameover_menu:GameOver 


func _ready():
	healthbar.value = health
	$AnimatedSprite2D.play("idle")
	rect_2.disabled = true
	circle_2.disabled = true
	#for sword 2
	recttop.disabled = true
	rectbottom.disabled = true
	#for sword 1
	var inventory_interface = preload("res://scenes/inventory/inventory_interface.tscn").instantiate()
	add_child(inventory_interface)

func get_input(): # movement
	if Input.is_action_just_pressed(action_attack_one):
		do_attack1()
	elif Input.is_action_just_pressed(action_attack_two):
		do_attack2()
	elif Input.is_action_just_pressed(action_dash):
		do_dash()
		
	if is_attacking or is_dashing:
		return
		
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO):
		velocity = velocity.lerp(input_direction * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	if Input.is_action_pressed('ui_right'):
		current_dir = "right"
	if Input.is_action_pressed('ui_left'):
		current_dir = "left"
		
	if (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO):
		play_anim(1)
	else:
		play_anim(0)

func _physics_process(delta):
	small_enemy_attack()
	get_input()
	if is_dashing:
		velocity = dash_velocity
	move_and_slide()
	small_enemy_attack()
	if health <= 0:
		player_alive = false
		speed = 0
		if not gameover_menu:
			gameover_menu = gameover_scene.instantiate() as GameOver
			add_child(gameover_menu)
			gameover_menu.set_score(Global.score)
	

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
	if dir == "left":
		anim.flip_h = true
	if movement == 1: 
		anim.play("walk")
	if movement == 0:
		anim.play("idle")

func try_play(anim_name):
	var anim_node := $AnimatedSprite2D
	var frames: SpriteFrames = anim_node.sprite_frames
	if frames and frames.has_animation(anim_name):
		anim_node.play(anim_name)
	else:
		anim_node.play("walk") # harmless fallback

func do_attack1():
	if is_attacking or is_dashing or attack1_on_cooldown:
		return
	is_attacking = true
	attack1_on_cooldown = true
	velocity = Vector2.ZERO
	try_play("attack1")
	await get_tree().create_timer(attack1_duration).timeout
	is_attacking = false
	await get_tree().create_timer(attack1_cooldown).timeout
	attack1_on_cooldown = false
func do_attack2():
	if is_attacking or is_dashing or attack2_on_cooldown:
		return
	is_attacking = true
	#rect_2.disabled = false
	#circle_2.disabled = false
	attack2_on_cooldown = true
	velocity = Vector2.ZERO
	try_play("attack2")
	await get_tree().create_timer(attack2_duration).timeout
	is_attacking = false
	#rect_2.disabled = true
	#circle_2.disabled = true
	await get_tree().create_timer(attack2_cooldown).timeout
	attack2_on_cooldown = false

func do_dash():
	if is_attacking or is_dashing or not can_dash:
		return

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir == Vector2.ZERO:
		# no movement keys? dash in last facing direction (left/right)
		if current_dir == "right":
			dir = Vector2.RIGHT
		elif current_dir == "left":
			dir = Vector2.LEFT
		else:
			return # nowhere to dash

	is_dashing = true
	can_dash = false
	dash_velocity = dir.normalized() * speed * dash_speed_multiplier
	try_play("dash")

	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false

	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("small_enemy"):
		small_enemy_inattack_range = true

func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.has_method("small_enemy"):
		small_enemy_inattack_range = false

func small_enemy_attack():
	if small_enemy_inattack_range and enemy_attack_cooldown == true: 
		health = health - 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		healthbar.value = health
		print ("is hit")

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true 
