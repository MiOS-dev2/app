import tkinter as tk
 
# Login form for MiOS (demo PIN: 1234)
pin = ""
tries = 0
 
def press(d):
    global pin
    if len(pin) < 8:
        pin = pin + d
    show.config(text="PIN: " + "*" * len(pin))
 
def clear():
    global pin
    pin = ""
    show.config(text="PIN: ")
 
def enter():
    global pin, tries
    if tries >= 3:
        status.config(text="Locked. Restart app")
    elif pin == "1234":
        status.config(text="Welcome, admin!")
        print("Login OK")
    else:
        tries = tries + 1
        status.config(text="Wrong PIN " + str(tries) + "/3")
        print("Login failed")
        clear()
 
root = tk.Tk()
root.title("MiOS Login")
 
title = tk.Label(root, text="== MiOS Login ==")
title.place(x=125, y=5)
show = tk.Label(root, text="PIN: ")
show.place(x=140, y=35)
status = tk.Label(root, text="Enter PIN (demo: 1234)")
status.place(x=100, y=65)
 
b = tk.Button(root, text="1", command=lambda: press("1"))
b.place(x=130, y=95)
b = tk.Button(root, text="2", command=lambda: press("2"))
b.place(x=180, y=95)
b = tk.Button(root, text="3", command=lambda: press("3"))
b.place(x=230, y=95)
 
b = tk.Button(root, text="4", command=lambda: press("4"))
b.place(x=130, y=130)
b = tk.Button(root, text="5", command=lambda: press("5"))
b.place(x=180, y=130)
b = tk.Button(root, text="6", command=lambda: press("6"))
b.place(x=230, y=130)
 
b = tk.Button(root, text="7", command=lambda: press("7"))
b.place(x=130, y=165)
b = tk.Button(root, text="8", command=lambda: press("8"))
b.place(x=180, y=165)
b = tk.Button(root, text="9", command=lambda: press("9"))
b.place(x=230, y=165)
 
b = tk.Button(root, text="C", command=clear)
b.place(x=130, y=200)
b = tk.Button(root, text="0", command=lambda: press("0"))
b.place(x=180, y=200)
b = tk.Button(root, text="OK", command=enter)
b.place(x=230, y=200)
 
root.mainloop()