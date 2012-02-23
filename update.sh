#!/bin/sh
#update the flashcards file

git add flashcards.txt
git commit -m "update questions - `date`"
git push origin master
