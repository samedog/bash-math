#!/bin/bash
##########################################################################################
# By Diego Cardenas "The Samedog" under GNU GENERAL PUBLIC LICENSE Version 2, June 1991
# (www.gnu.org/licenses/old-licenses/gpl-2.0.html) e-mail: the.samedog[]gmail.com.
# https://github.com/samedog/frankenpup64
##########################################################################################

#supports large inputs (comma separated)
#this supports both negative and positive numbers
#also suports -- +- -+ etc kinda multipurpose 
function addsubs(){
	for var in "$@"
	do
		(( cnt += $var ))
	done
	echo $cnt
}

# $1^$2 doesn't works with negative exponents (yet)
function pow(){
	cnt=1
	for (( c=1; c<=$2; c++ ))
	do  
	   (( cnt *= $1 ))
	done
	echo $cnt
}

# this is hacky as hell but it works
# can add non floats and will return a float
# NOW IT SUPPORTS NEGATIVE FLOATS AND INTS
function sum_float(){
	int_cnt=0
	bigger_cnt=0
	decimal_sum=0
	whole_remaining=""
	for i in "$@"
	do IFS=","
		set -- $i
		int_cnt=${#2}
		if [ $int_cnt -gt $bigger_cnt ];then
			bigger_cnt=$int_cnt
		fi
		if [[ $1 == "-"* ]];then
			decimals+="-$2,"
		else
			decimals+="$2,"
		fi
		
		(( whole += $1 ))
		
	done
	
	for value in $decimals
	do
		if [ ${#value} -lt $bigger_cnt ];then
			zeroes=$(( $bigger_cnt - ${#value} ))
			for (( i=0; i<$zeroes; i++ ))
			do
				(( value *= 10 ))
			done
		fi
		if [[ -z $value || $value == "-" ]];then
			value="0"
		fi
		(( decimal_sum += $value ))
		
	done
	if [ ${#decimal_sum} -gt $bigger_cnt ];then
		offset=$(( ${#decimal_sum} - $bigger_cnt ))
		decimal_sum_final=${decimal_sum:$offset}
		whole_remaining=${decimal_sum::$offset}
		if [ $decimal_sum -lt 0 ];then
			tens=1
			temp_sum=${decimal_sum#?};
			for ((i=0; i<${#temp_sum}; i++))
			do
				(( tens *= 10 )) 
			done
			decimal_sum=$(( tens - $temp_sum ))
			whole=$(( $whole + -1 ))
		fi
	else
		decimal_sum_final=$decimal_sum
	fi
	if [[ ! -z $whole_remaining && $whole_remaining != "-" ]];then
		whole=$(( $whole + $whole_remaining ))
	fi
	if [ -z $decimal_sum_final ];then
		decimal_sum_final=0
	fi
	echo $whole,$decimal_sum_final
}
