

import os, sys, mp3play, time


def sound_it(filename):
	mp3 = mp3play.load(filename)
	mp3.play()
	time.sleep(min(2, mp3.seconds()))
	mp3.stop()
	
	
sound_file = sys.argv[1]
sound_it(sound_file)





