extends CharacterBody2D
enum State {
	Moving,
	Transitioning,
	Swinging
}
@export var speed = 300.0
@export var jump_vel = -400.0
@export var friction:float = 0.1;
@export var accel:float = 0.1;
@export var tongue_length:float = 100;
@export var tongue_extend_speed = 0.5;
@export var tongue_grapple_point_sprite:Node2D
@export var tongue_sprite:Sprite2D;

var tongue_sprite_connect_pos:Node2D;

var dir = 1;

var state:State = State.Moving;

var tongue_ray:RayCast2D;
var tongue_length_normalizer:float;

var tongue_grapple_point:Vector2;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_vel:Vector2 = Vector2(0, 0);


func _ready():
	tongue_ray = $TongueRay;
	tongue_length_normalizer = 1.0 / tongue_sprite.texture.get_height();
	tongue_ray.target_position = tongue_ray.target_position.normalized() * tongue_length;
	tongue_sprite_connect_pos = $Sprite/TonguePos;
	
	tongue_sprite.visible = false;
func _physics_process(delta):
	if (state != State.Transitioning):
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

	if (state == State.Moving):
		check_flip();
		if Input.is_action_just_pressed("action"):
			if (is_on_floor()):
				jump();
		if Input.is_action_just_released("action"):
			print("hello");
			change_state(State.Transitioning)
		
		# Get the input direction and handle the movement/deceleration.
		target_vel.x = dir * speed;
		velocity.x = move_toward(velocity.x, target_vel.x, accel);
		
		$Sprite.rotate(velocity.x/1000);
		
		if ($WallRay.is_colliding()):
			dir *= -1;
			velocity.x = dir * speed;
		
	if (state == State.Transitioning):
		var target_tongue_length:float = (tongue_grapple_point - position).length() * tongue_length_normalizer
		tongue_sprite.scale.y = move_toward(tongue_sprite.scale.y, target_tongue_length, tongue_extend_speed);
		update_tongue_visuals(false);
		if (abs(target_tongue_length - tongue_sprite.scale.y) < tongue_extend_speed):
			tongue_sprite.scale.y = target_tongue_length;
			change_state(State.Swinging);
		
	if (state == State.Swinging):
		
		var dir_to_grapple = (tongue_grapple_point - position).normalized();
		var speed_towards_point = velocity.dot(dir_to_grapple) 
		if (position.distance_to(tongue_grapple_point) > tongue_length):
			velocity -= speed_towards_point * dir_to_grapple;
			#position = tongue_grapple_point - dir_to_grapple * tongue_length;
		if (Input.is_action_just_pressed("action")):
			change_state(State.Moving);
			jump();
			dir = sign(velocity.x);
		

	move_and_slide()
	update_tongue_visuals();
	tongue_sprite.position = tongue_sprite_connect_pos.global_position;

func jump():
	velocity.y += jump_vel;
	
func grab_grapple_point():
	var collider = tongue_ray.get_collider()
	tongue_grapple_point = tongue_ray.get_collision_point();
	tongue_length = position.distance_to(tongue_grapple_point);
	
func check_flip():
	if (sign(dir) != sign($WallRay.target_position.x)):
		$TongueRay.target_position.x *= -1;
		$WallRay.target_position.x *= -1;
		if (round($TongueGuide.rotation_degrees) == -135):
			$TongueGuide.rotation_degrees -= 90;
		else:
			$TongueGuide.rotation_degrees += 90;

func change_state(new_state:State):
	tongue_grapple_point_sprite.visible = false;
	if new_state == State.Moving:
		tongue_sprite.visible = false;
	if new_state == State.Swinging:
		tongue_sprite.visible = true;
		var artificial_vel = (tongue_grapple_point - position);
		artificial_vel.y *= -1;
		artificial_vel *= 1;
		velocity += artificial_vel;
		tongue_grapple_point_sprite.visible = true;
		tongue_grapple_point_sprite.position = tongue_grapple_point;
		
		update_tongue_visuals();

	if new_state == State.Transitioning:
		grab_grapple_point();

	
	state = new_state;

func update_tongue_visuals(update_scale = true):
	var pointing_vec = (tongue_grapple_point - position);
	
	if (update_scale): tongue_sprite.scale.y = pointing_vec.length() * tongue_length_normalizer;
	tongue_sprite.rotation = pointing_vec.angle() + PI/2;
