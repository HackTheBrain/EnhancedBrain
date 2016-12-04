from Tkinter import * 
import Tkinter 
from PIL import Image, ImageTk 

def background_fish_it(pic_file): 
    root = Tk() 
    root.overrideredirect(True) 
    root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight())) 

    im = Image.open(pic_file) 
    im = im.resize((root.winfo_screenwidth(), root.winfo_screenheight())) 
    tkimage = ImageTk.PhotoImage(im) 
    Label(root,image = tkimage, bd=0).pack() 

    root.after(150, lambda: root.destroy()) 
    root.mainloop() 

if len(sys.argv)==1: 
    print "You should use it like \"fish.py <path to the picture file>\"" 
    quit() 

pic_file = sys.argv[1] 
background_fish_it(pic_file)
