#!/bin/bash

clear
echo "Let's build a mad-lib!"

read -p "1. Please give me an adjective: " ADJ1
read -p "2. Please give me a noun: " NOU1
read -p "3. Please give me a plural noun: " PNOU
read -p "4. Please give me a name: " NAM
read -p "5. Please give me an adjective: " ADJ2
read -p "6. Please give me an article of clothing: " AOC                      
read -p "7. Please give me a noun: " NOU2
read -p "8. Please give me a city: " CIT


echo "There are many $ADJ1 ways to choose a/an $NOU1 to read. First, 
you could ask for recommendations from your friends and $PNOU. Just don't
ask Aunt $NAM--she only reads $ADJ2 books with $AOC-ripping goddesses 
on the cover. If your friends and family are no help, try checking out 
the $NOU2 Review in The $CIT Times."
