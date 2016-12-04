#!/usr/bin/python

'''
this script runs the simple test: it asks to calculate the sum of two random numbers
it writes logs by path 
'''



import Tkinter
import random
import time
import os




class simpleapp_tk(Tkinter.Tk):
    def __init__(self,parent):
		Tkinter.Tk.__init__(self,parent)
		self.parent = parent
		self.initialize()
		
		
		
		
	

    def initialize(self):
		self.grid()
		
		self.log_file = 'logs\log_'+str(time.time())+'.txt'
		if not os.path.exists('logs'):
			os.makedirs('logs')
		
		
		b = random.randrange(1,100)
		a = random.randrange(1,100)
		self.answer = a+b
		c = str(a) + ' + ' + str(b)
		self.st = time.time()
		
		self.labelVariable = Tkinter.StringVar()
		label = Tkinter.Label(self,textvariable=self.labelVariable,
							  anchor="w",fg="white",bg="blue",width=100, font=("Courier", 44))
		label.place(x=300, y=0)
		label.grid(column=0,row=0,columnspan=2,sticky='EW')
		
		self.labelVariable.set(u"Answer : " + c)
		
		
		
		self.entryVariable = Tkinter.StringVar()
		self.entry = Tkinter.Entry(self,textvariable=self.entryVariable, width=50, font=("Courier", 44))
		self.entry.grid(column=0,row=1,sticky='EW')
		self.entry.bind("<Return>", self.OnPressEnter)

		
		self.entryVariable.set("")

		button = Tkinter.Button(self,text=u"answer!",
								command=self.OnButtonClick, width=20, font=("Courier", 44))
		button.grid(column=1,row=1)	
		self.grid_columnconfigure(0,weight=1)	
		self.resizable(True,False)
		
		


    def OnButtonClick(self):
		
        #self.labelVariable.set( self.entryVariable.get()+" (You clicked the button)" )
		get_c = self.entryVariable.get()
		f = open(self.log_file, 'a')
		s = str(self.answer)  + ';' + str(get_c.strip()) + ';'+str(time.time() -  self.st) + '\n'
		f.write(s)
		f.close()
		self.entryVariable.set('')
		
		a = random.randrange(1,100)
		b = random.randrange(1,100)
		self.answer = a+b
		c = str(a) + ' + ' + str(b)
		self.labelVariable.set(u"Answer : " + c)
		

    def OnPressEnter(self,event):
		self.OnButtonClick()
        #self.labelVariable.set( self.entryVariable.get()+" (You pressed ENTER)" )
		



		

if __name__ == "__main__":
    app = simpleapp_tk(None)
    app.title('my application')
    app.mainloop()