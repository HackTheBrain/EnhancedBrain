from Tkinter import *
import time

def blink_it():
	root = Tk()
	root.overrideredirect(True)
	root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
	root.after(100, lambda: root.destroy())
	root.mainloop()
	

for i in range(1,4):
	blink_it()
	time.sleep(0.0001)
