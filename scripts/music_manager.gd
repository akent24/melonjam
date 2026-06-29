extends AudioStreamPlayer

func play_music(path: String):
	if stream != null and stream.resource_path == path:
		return
	stream = load(path)
	play()

func stop_music() -> void:
	stop()
