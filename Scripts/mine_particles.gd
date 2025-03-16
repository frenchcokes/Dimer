extends GPUParticles2D

func _ready():
	self.finished.connect(self_destruct)
	self.emitting = true
	
func self_destruct():
	self.queue_free()
