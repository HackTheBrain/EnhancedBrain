from Tkinter import *
import Tkinter
from PIL import ImageGrab,ImageTk
import time


def zoom_it(coef):
	# printscreen
	im=ImageGrab.grab()
	
	
	root = Tk()
	root.overrideredirect(True)
	root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))

	# printscreen
	
	im=ImageGrab.grab()
	im = im.resize((int(coef*root.winfo_screenwidth()), int(coef*root.winfo_screenheight())))
	tkimage = ImageTk.PhotoImage(im)
	Label(root,image = tkimage, bd=0).pack()

	root.after(150, lambda: root.destroy())
	root.mainloop()
	


zoom_it(1.5)
zoom_it(1.5)



