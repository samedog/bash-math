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
# add or substract 2 floats
# if a single int is given it will return a float
function sum_float(){
	if [[ ${#@} -gt 2 ]];then
		echo "too may arguments"
		exit 1
	fi
	DECIMAL_COUNT=0
	OLD_IFS=$IFS
	for i in "$@"
	do IFS=","
		set -- $i
		int_cnt=${#2}
		if [ $int_cnt -gt $DECIMAL_COUNT ];then
			DECIMAL_COUNT=$int_cnt
		fi

		DECIMAL_ARRAY+=("$2")
		WHOLE_ARRAY+=("$1")
		
	done
	IFS=$OLD_IFS
	
	
	for (( i=0; i<${#DECIMAL_ARRAY[@]}; i++ ))
	do
		tmp_zeroes=0
		tmp_count=$DECIMAL_COUNT+1
		NEGATIVE=0
		value=${DECIMAL_ARRAY[$i]}
		whole_value=${WHOLE_ARRAY[$i]}
		if [ -z $value ];then
			(( tmp_zeroes += 1))
		fi
		(( tmp_count += $tmp_zeroes))
		join_value=$whole_value$value
		if [ $join_value -lt 0 ];then
			NEGATIVE=1
			(( join_value *= -1 )) 
		fi
		
		if [ ${#join_value} -lt $tmp_count ];then
			zeroes=$(( $tmp_count - ${#join_value} ))
			for (( i=0; i<$zeroes; i++ ))
			do
				(( join_value *= 10 ))
			done
		fi
		if [ $NEGATIVE -eq 1 ];then
			(( join_value *= -1 ))
		fi
		JOIN_ARRAY+=($join_value)
	done
	
	
	
	FIRST=${JOIN_ARRAY[0]}
	SECOND=${JOIN_ARRAY[1]}


	if [[ -z $SECOND || -z $FIRST ]];then
		RESULT="$(( $SECOND + $FIRST )),0"
	else
		if [ $FIRST -gt $SECOND ];then
			RESULT=$(( $FIRST + $SECOND ))
		else
			RESULT=$(( $SECOND + $FIRST ))
		fi
		if [ $RESULT -lt 0 ];then
			NEGATIVE=1
			(( RESULT *= -1 )) 
		fi
		
		if [ ${#RESULT} -lt $DECIMAL_COUNT ];then
			zeroes=$(( $DECIMAL_COUNT -1 ))
			for (( i=0; i<$zeroes; i++ ))
			do
				REBASED_RESULT+="0"
			done
			RESULT=$REBASED_RESULT$RESULT
		fi
		
		
		
		COMMA_PLACE=$(( ${#RESULT} - $DECIMAL_COUNT ))
		PLACE=${RESULT:$COMMA_PLACE:1}
		
			
		PLACE=${RESULT:$COMMA_PLACE-1:1}
		for (( i=0; i<${#RESULT}; i++ )); do
			if [ $i -eq $COMMA_PLACE ];then
				RESULT_TMP+=","
			fi
			RESULT_TMP+="${RESULT:$i:1}"
		done
		
		RESULT=$RESULT_TMP
		
		if [ ${RESULT:0:1} == "," ];then
			RESULT=${RESULT/","/"0,"}
		fi
		
		if [[ $NEGATIVE -eq 1 ]];then
			RESULT=${RESULT/${RESULT:0:1}/-${RESULT:0:1}}
		fi

	fi
	

		echo $RESULT
}

function mult_float(){
	if [[ ${#@} -gt 2 ]];then
		echo "too may arguments"
		exit 1
	fi
	DECIMAL_COUNT=0
	WHOLE_COUNT=0
	OLD_IFS=$IFS
	RESULT=1
	for i in "$@"
	do IFS=","
		set -- $i
		dec_cnt=${#2}
		whl_cnt=${#1}
		if [ $dec_cnt -gt $DECIMAL_COUNT ];then
			DECIMAL_COUNT=$dec_cnt
		fi
		
		(( WHOLE_COUNT += $whl_cnt ))
		
		if [[ -z $2 ]];then
			DECIMAL_ARRAY+=("0")
		else
			DECIMAL_ARRAY+=("$2")
		fi
		
		
		WHOLE_ARRAY+=("$1")
		
	done
	IFS=$OLD_IFS

	
	for (( i=0; i<${#DECIMAL_ARRAY[@]}; i++ ))
	do
		tmp_zeroes=0
		tmp_count=$DECIMAL_COUNT
		value=${DECIMAL_ARRAY[$i]}
		whole_value=${WHOLE_ARRAY[$i]}
		if [ -z $value ];then
			(( tmp_zeroes += 1))
		fi
		(( tmp_count += $tmp_zeroes))
		join_value=$whole_value$value
		if [ ${#join_value} -lt $tmp_count ];then
			zeroes=$(( $tmp_count - ${#join_value} ))
			for (( i=0; i<$zeroes; i++ ))
			do
				(( join_value *= 10 ))
			done
		fi
		JOIN_ARRAY+=($join_value)
	done
	
	
	for element in ${JOIN_ARRAY[@]}
	do
		(( RESULT *= $element ))
	done

	if [ $RESULT -lt 0 ];then
		NEGATIVE=1
		(( RESULT *= -1 )) 
	fi

	COMMA_PLACE=$(( $WHOLE_COUNT - 2 ))

	
	PLACE=${RESULT:$COMMA_PLACE:1}
	for (( i=0; i<${#RESULT}; i++ )); do
		if [ $i -eq $COMMA_PLACE ];then
			RESULT_TMP+=","
		fi
		RESULT_TMP+="${RESULT:$i:1}"
	done
			
	RESULT=$RESULT_TMP
	
	if [ ${RESULT:0:1} == "," ];then
		RESULT=${RESULT/","/"0,"}
	fi
	
	if [[ $NEGATIVE -eq 1 ]];then
		RESULT=${RESULT/${RESULT:0:1}/-${RESULT:0:1}}
	fi
	echo $RESULT
}

