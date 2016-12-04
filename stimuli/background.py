from Tkinter import *
import time

def background_it(color):
	root = Tk()
	root.overrideredirect(True)
	root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
	root.after(100, lambda: root.destroy())
	root.attributes('-alpha', 0.6)
	root.configure(background=color)
	root.mainloop()
	

for i in range(1,4):
	background_it('yellow')
	background_it('green')
	background_it('red')
	
