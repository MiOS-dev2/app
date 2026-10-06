import tkinter as tk

count = 0

def clicked():
    global count
    count = count + 1
    lbl.config(text="Clicks: " + str(count))

root = tk.Tk()
root.title("Hello MP")
lbl = tk.Label(root, text="Clicks: 0")
lbl.pack()
btn = tk.Button(root, text="Click me", command=clicked)
btn.pack()
root.mainloop()
