#!/bin/sh
#asks random questions from a file then prompts the user to press enter to see the answer.
FILE="flashcards.txt"
clear

:<<USAGECOMMENT
Usage: $0 to ask random questions infinitely
$0 norepeat to ask all questions in a random order without repeating, and quitting at the end
$0 sequence to ask from beginning to end
$0 sequence reverse to ask in reverse order
Press q to exit after a question or answer
USAGECOMMENT

function quit() {
	[ "$1" == 9999 ] && echo "Out of questions!"
	echo "Hope you learned something. Bye!"
	[ -e $SORTED_FILE ] && [ ! -z "$SORTED_FILE" ] && rm $SORTED_FILE
	exit $1
}


if [ "$1" == "sequence" ] || [ "$1" == "norepeat" ]; then
	LINES=`cat $FILE | wc -l`
	if [ "$2" != "reverse" ]; then
		echo "Sequential mode activated."
		echo ""
		INCREMENT=0
	else
		echo "Reverse sequential mode activated."
		echo ""		
		INCREMENT=$LINES
	fi
	if [ "$1" == "norepeat" ]; then
	  clear
	  echo "No repeat mode activated."
	  SORTED_FILE="$FILE-sorted"	  
	  cat $FILE | while read f ; do printf "$RANDOM\t%s\n" "$f"; done | sort -n | cut -f2- > $SORTED_FILE
 	  FILE=$SORTED_FILE
	fi
	

	while [ $INCREMENT -le $LINES ]; do
	   if [ -z "$2" ]; then   
			let INCREMENT=$INCREMENT+1
		else
			let INCREMENT=$INCREMENT-1
		fi
		QUESTION=`cat $FILE | head -n $INCREMENT | tail -n 1 | awk -F '::' '{print$1}'`  
		ANSWER=`cat $FILE | head -n $INCREMENT | tail -n 1 | awk -F '::' '{print$2}'`
		[ $INCREMENT -lt 10 ] && STARS="############"
		[ $INCREMENT -ge 10 ] && [ $INCREMENT -le 99 ] && STARS="#############"
		[ $INCREMENT -ge 100 ] && [ $INCREMENT -le 999 ] && STARS="##############"
		echo $STARS
		echo "*QUESTION $INCREMENT*"
		echo $STARS
		echo $QUESTION | fmt -w 60
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
		clear
		[ "$PAUSE" == "q" ] && quit 0
	done
	quit 9999	
fi

LEAVE=0
while [ $LEAVE -ne 1 ]; do
  LINES=`cat $FILE | wc -l`
  RANDLINE=`expr $RANDOM % $LINES + 1` #ensure the line is not 0, so add 1

  QUESTION=`cat $FILE | sed ''"$RANDLINE"'!d' | awk -F '::' '{print$1}'`  
  ANSWER=`cat $FILE | sed ''"$RANDLINE"'!d' | awk -F '::' '{print$2}'`
  [ $RANDLINE -lt 10 ] && STARS="############"
  [ $RANDLINE -ge 10 ] && [ $RANDLINE -le 99 ] && STARS="#############"
  [ $RANDLINE -ge 100 ] && [ $RANDLINE -le 999 ] && STARS="##############"
  echo $STARS
  echo "*QUESTION $RANDLINE*"
  echo $STARS
  echo $QUESTION | fmt -w 60
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
	 clear
	 if [ "$PAUSE" == "q" ]; then
		 LEAVE=1
	 fi	
 else
    LEAVE=1
 fi
 done
quit 0