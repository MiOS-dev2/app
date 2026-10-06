import tkinter as tk

root = tk.Tk()
root.geometry("600x400")
root.title("Text Edit")


entry = tk.Entry(root, font=("Arial", 14))
entry.grid(row=0, column=0, sticky="nsew")

root.mainloop()