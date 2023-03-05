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
@export var tongue_suck_force = 20;

var dir = 1;

var state:State = State.Moving;

var tongue_ray:RayCast2D;
var tongue_sprite:Sprite2D;
var tongue_length_normalizer:float;

var tongue_grapple_point:Vector2;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_vel:Vector2 = Vector2(0, 0);


func _ready():
	tongue_sprite = $Sprite/Tongue;
	tongue_ray = $TongueRay;
	tongue_length_normalizer = 1.0 / tongue_sprite.texture.get_height();
	tongue_ray.target_position = tongue_ray.target_position.normalized() * tongue_length;
func _physics_process(delta):
	
	if (state != State.Transitioning):
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

	if (state == State.Moving):
		if (sign(dir) != sign($WallRay.target_position.x)):
			print ($TongueGuide.rotation_degrees)
			if (round($TongueGuide.rotation_degrees) == -135):
				print("hallo");
				$TongueGuide.rotation_degrees -= 90;
			else:
				$TongueGuide.rotation_degrees += 90;
			$TongueRay.target_position.x *= -1;
			$WallRay.target_position.x *= -1;
		if Input.is_action_just_pressed("action"):
			if (is_on_floor()):
				velocity.y += jump_vel;
			elif (tongue_ray.is_colliding()):
				var collider = tongue_ray.get_collider()
				tongue_grapple_point = tongue_ray.get_collision_point();
				tongue_length = position.distance_to(tongue_grapple_point);
				change_state(State.Transitioning);
		
		# Get the input direction and handle the movement/deceleration.
		target_vel.x = dir * speed;
		velocity.x = move_toward(velocity.x, target_vel.x, accel);
		
		$Sprite.rotate(velocity.x/2000);
		
		if ($WallRay.is_colliding()):
			dir *= -1;
			velocity.x = dir * speed;
		
	if (state == State.Transitioning):
		var target_tongue_length:float = (tongue_grapple_point - position).length() * tongue_length_normalizer
		tongue_sprite.scale.y = move_toward(tongue_sprite.scale.y, target_tongue_length, tongue_extend_speed);
		
		if (abs(target_tongue_length - tongue_sprite.scale.y) < tongue_extend_speed):
			tongue_sprite.scale.y = target_tongue_length;
			change_state(State.Swinging);
		
			
		if (Input.is_action_just_released("action")):
			change_state(State.Moving);
		
	if (state == State.Swinging):
		var pointing_vec = (tongue_grapple_point - position);
		
		tongue_sprite.scale.y = pointing_vec.length() * tongue_length_normalizer;
		tongue_sprite.rotation = pointing_vec.angle() - $Sprite.rotation + PI/2;
		
		var dir_to_grapple = (tongue_grapple_point - position).normalized();
		var speed_towards_point = velocity.dot(dir_to_grapple) 
		if (position.distance_to(tongue_grapple_point) > tongue_length):
			velocity -= speed_towards_point * dir_to_grapple;
			position = tongue_grapple_point - dir_to_grapple * tongue_length;
		if (Input.is_action_just_released("action")):
			change_state(State.Moving);
			velocity.y += jump_vel;
			dir = sign(velocity.x);
			

	
	move_and_slide()

func change_state(new_state:State):
	tongue_grapple_point_sprite.visible = false;
	if new_state == State.Moving:
		tongue_sprite.scale.y = 0;
	if new_state == State.Swinging:
		var artificial_vel = (tongue_grapple_point - position);
		artificial_vel.y *= -1;
		artificial_vel *= 5;
		#velocity += artificial_vel;
		tongue_grapple_point_sprite.visible = true;
		tongue_grapple_point_sprite.position = tongue_grapple_point;
	if new_state == State.Transitioning:
		pass
		#velocity = Vector2.ZERO;
	
	state = new_state;
