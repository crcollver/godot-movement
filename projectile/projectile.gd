extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Projectile_body_entered(_body):
	queue_free()
