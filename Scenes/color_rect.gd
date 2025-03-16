extends ColorRect

# Time tracking
var time_of_day = 0.0
var cycle_duration = 10.0  # Duration of a full day/night cycle in seconds (adjustable)

# Define the colors for different times of the day
var color_day = Color(0.53, 0.81, 0.92)  # Sky Blue for day
var color_dusk = Color(0.0, 0.0, 0.5)    # Dark Blue for dusk/evening
var color_night = Color(0.0, 0.0, 0.0)   # Black for night

func _process(delta):
	# Increment time, wrapping around using fmod() for safety
	time_of_day = fmod(time_of_day + delta, cycle_duration)
	# Calculate the current time ratio
	var t = time_of_day / cycle_duration

	# Interpolate color based on the time of day
	# Define transitions (adjust times as needed for your game's feel)
	var transition_to_dusk_start = 0.5  # 50% of the day is daylight
	var transition_to_night_start = 0.8  # 80% starts transitioning to night

	if t < transition_to_dusk_start:
		# Day to Dusk transition
		var normalized_time = t / transition_to_dusk_start
		color = color_day.lerp(color_dusk, normalized_time)
	elif t < transition_to_night_start:
		# Dusk to Night transition
		var normalized_time = (t - transition_to_dusk_start) / (transition_to_night_start - transition_to_dusk_start)
		color = color_dusk.lerp(color_night, normalized_time)
	else:
		# Night
		var normalized_time = (t - transition_to_night_start) / (1.0 - transition_to_night_start)
		color = color_night  # stays black at night
