#!/bin/sh
#asks random questions from a file then prompts the user to press enter to see the answer.
FILE="flashcards.txt"

echo "Welcome."
echo $1
LINES=`cat $FILE | wc -l`
RANDLINE=`expr $RANDOM % $LINES + 1` #ensure the line is not 0, so add 1

QUESTION=`cat $FILE | head -n $RANDLINE | tail -n 1 | awk -F '::' '{print$1}'`  
ANSWER=`cat $FILE | head -n $RANDLINE | tail -n 1 | awk -F '::' '{print$2}'`

function quit() {
	[ "$1" == 9999 ] && echo "Out of questions!"
	echo "Hope you learned something. Bye!"
	exit $1
}

if [ ! -z "$1" ]; then
	echo "Sequential mode activated."
	INCREMENT=0
	while [ $INCREMENT -le $LINES ]; do
		let INCREMENT=$INCREMENT+1
		echo "QUESTION: $INCREMENT"
		QUESTION=`cat $FILE | head -n $INCREMENT | tail -n 1 | awk -F '::' '{print$1}'`  
		ANSWER=`cat $FILE | head -n $INCREMENT | tail -n 1 | awk -F '::' '{print$2}'`
		clear
		echo "************"
		echo "*QUESTION $INCREMENT*"
		echo "************"
		echo $QUESTION
		echo ""
		echo "Press enter to see the answer..."
		read key
		[ "$key" == "q" ] && quit 0
		echo "********"
		echo "*ANSWER*"
		echo "********"
		echo $ANSWER
		echo ""
		echo "Press enter to see another question..."
		read PAUSE
		[ "$PAUSE" == "q" ] && quit 0
	done
	quit 9999	
fi

clear
echo "************"
echo "*QUESTION $RANDLINE*"
echo "************"
echo $QUESTION
echo ""
echo "Press enter to see the answer..."
read key
if [ "$key" != "q" ]; then
	echo "********"
	echo "*ANSWER*"
	echo "********"
	echo $ANSWER
	echo ""
	echo "Press enter to see another question..."
	read PAUSE
	if [ "$PAUSE" != "q" ]; then
		./flash.sh
	else
		quit 0
	fi	
else
	quit 0
fi
