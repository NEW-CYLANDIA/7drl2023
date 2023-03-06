extends KinematicBody2D
enum State {
	Moving,
	Swinging
}
enum RotateState {
	Locked45,
	Spinning,
}
export var speed = 300.0
export var jump_vel = -400.0
export var accel:float = 0.1;
export var tongue_length:float = 100;
export var tongue_extend_speed = 0.5;
export var spin_speed:float = 0.05;

export var mood_add:float = 3;
export var mood_subtract:float = 0.5;
export(RotateState) var rotate_state:int = RotateState.Locked45;

export(NodePath) var tongue_grapple_point_sprite_path:String
onready var tongue_grapple_point_sprite:Sprite = get_node(tongue_grapple_point_sprite_path);

export(NodePath) var tongue_sprite_path:String
onready var tongue_sprite:Sprite = get_node(tongue_sprite_path)

export(NodePath) var tilemap_path;
onready var tilemap:TileMap = get_node(tilemap_path);

export(NodePath) var taste_buds_path;
onready var taste_buds = get_node(taste_buds_path);



var tongue_sprite_connect_pos:Node2D;

var dir = 1;

var state:int = State.Moving;
var tongue_ray:RayCast2D;
var tongue_length_normalizer:float;

var tongue_grapple_point:Vector2;

var velocity:Vector2 = Vector2();

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_vel:Vector2 = Vector2(0, 0);


func _ready():
	tongue_ray = $TongueRay;
	tongue_length_normalizer = 1.0 / tongue_sprite.texture.get_height();
	tongue_ray.cast_to = tongue_ray.cast_to.normalized() * tongue_length;
	tongue_sprite_connect_pos = $Sprite/TonguePos;
	tongue_sprite.visible = false;
func _physics_process(delta):
	
	move_and_slide(velocity, Vector2.UP,false, 4, 0.78, false);
	var collision_data = get_slide_collision(get_slide_count() - 1);
	
	if (not is_on_floor()):
		velocity.y += gravity * delta
	else:
		pass;
	
	

	if (state == State.Moving):
		$Sprite.rotate(dir * spin_speed);
		if Input.is_action_just_pressed("action"):
			if (is_on_floor()):
				jump();
			elif tongue_ray.is_colliding():
				change_state(State.Swinging)
		
		# Get the input direction and handle the movement/deceleration.
		target_vel.x = dir * speed;
		velocity.x = move_toward(velocity.x, target_vel.x, accel);
		if (collision_data):
			if (abs(collision_data.normal.x) > 0.5):
				velocity.x = (velocity.bounce(collision_data.normal) * 0.5).x;
				dir = sign(velocity.x);
		if (is_on_ceiling()):
			velocity.y = 0;
		
	if (state == State.Swinging):
		var dir_to_grapple = (tongue_grapple_point - position).normalized();
		var speed_towards_point = velocity.dot(dir_to_grapple) 
		if (position.distance_to(tongue_grapple_point) > tongue_length):
			velocity -= speed_towards_point * dir_to_grapple;
			position = tongue_grapple_point - dir_to_grapple * tongue_length;
		if (Input.is_action_just_released("action")):
			change_state(State.Moving);
			jump();

		if (collision_data):
			velocity = velocity.bounce(collision_data.normal) * 0.5;
		dir = sign(velocity.x);
	
	update_tongue_visuals();
	
	if (rotate_state == RotateState.Spinning):
		tongue_ray.rotation_degrees = $Sprite.rotation_degrees - 45;
		
	check_flip();

func jump():
	velocity.y = jump_vel;
	
func grab_grapple_point():
	tongue_ray.collide_with_bodies
	var collider = tongue_ray.get_collider()
	var collision_point = tongue_ray.get_collision_point();
	var collision_normal = tongue_ray.get_collision_normal();
	
	var tilemap_pos = tilemap.world_to_map(collision_point - collision_normal);
	var tile_hit = tilemap.get_cellv(tilemap_pos);
	var tile_hit_name = tilemap.tile_set.tile_get_name(tile_hit);
	
	var buds_dict:Dictionary = taste_buds.taste_buds;
	if (buds_dict.has(tile_hit_name)):
		var affected_bud = buds_dict[tile_hit_name]
		affected_bud.add_mood(mood_add);

		for bud in buds_dict.values():
			print(bud);
			if (bud != affected_bud):
				bud.add_mood(-mood_subtract);

	tongue_grapple_point = collision_point
	tongue_length = position.distance_to(tongue_grapple_point);
	
func check_flip():
	
	if (rotate_state == RotateState.Locked45): 
		tongue_ray.rotation_degrees = 0;
	if (sign(dir) != sign($WallRay.cast_to.x)):
		if (rotate_state == RotateState.Locked45): tongue_ray.cast_to.x *= -1;
		$WallRay.cast_to.x *= -1;
#		if (round($TongueGuide.rotation_degrees) == -135):
#			$TongueGuide.rotation_degrees -= 90;
#		else:
#			$TongueGuide.rotation_degrees += 90;

func change_state(new_state:int):
	tongue_grapple_point_sprite.visible = false;
	if new_state == State.Moving:
		tongue_sprite.visible = false;

	if new_state == State.Swinging:
		grab_grapple_point();
		tongue_sprite.visible = true;
		var artificial_vel = (tongue_grapple_point - position);
		artificial_vel.y *= -1;
		artificial_vel *= 1;
		velocity += artificial_vel;
		tongue_grapple_point_sprite.visible = true;
		tongue_grapple_point_sprite.position = tongue_grapple_point;
		
		update_tongue_visuals();
	state = new_state;

func update_tongue_visuals(update_scale = true):
	var pointing_vec = (tongue_grapple_point - tongue_sprite_connect_pos.global_position);
	
	if (update_scale): tongue_sprite.scale.y = pointing_vec.length() * tongue_length_normalizer;
	tongue_sprite.rotation = pointing_vec.angle() + PI/2;
	tongue_sprite.position = tongue_sprite_connect_pos.global_position;
