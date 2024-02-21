#!/usr/local/bin/python3

import os

FAV_COLOR = input('What is your favorite color? ')
CITY= input('What is your favorite city? ')
FOOD= input('What is your favorite food? ' )

os.environ["FAV_COLOR"] = FAV_COLOR
os.environ["CITY"] = CITY
os.environ["FOOD"] = FOOD

print("Favorite Color:", os.getenv("FAV_COLOR"))
print("Favorite City:", os.getenv("CITY"))
print("Favorite Food:", os.getenv("FOOD"))