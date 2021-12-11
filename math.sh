#!/bin/bash
##########################################################################################
# By Diego Cardenas "The Samedog" under GNU GENERAL PUBLIC LICENSE Version 2, June 1991
# (www.gnu.org/licenses/old-licenses/gpl-2.0.html) e-mail: the.samedog[]gmail.com.
# https://github.com/samedog/bash-math
##########################################################################################
# addsubs not needed since sum_float now suppoerts multiple inputs
# $1^$2
function fpow(){
    if [[ ${#@} -gt 2 ]];then
        echo "too may arguments"
        exit 1
    fi
    result=1
    base=$1
    exponent=$2
    if [[ $base -gt 0 ]] && [[ $exponent -gt 0 ]] || [[ $base -lt 0 ]] && [[ $exponent -gt 0 ]];then
        for (( i=1; i<=$exponent; i++ ))
             do  
            (( result *= base ))
         done
    elif [[ $base -gt 0 ]] && [[ $exponent -lt 0 ]];then
        exponent=$(( exponent *= -1 ))
        for (( i=1; i<=$exponent; i++ ))
        do  
           (( result *= base ))
        done
        result=$(div_float 1 $result)
    elif [[ $base -lt 0 ]] && [[ $exponent -lt 0 ]];then
        exponent=$(( exponent *= -1 ))
        base=$(( base *= -1 ))
        for (( i=1; i<=$exponent; i++ ))
        do  
           (( result *= base ))
        done
       result=$(div_float 1 $result)
    fi
   
    echo $result
}

# can add non floats and will return a float
# add or substract

function sum_float(){
    DECIMALS=1
    # exact number of decimals must be knwow before any operation
    for i in $@
    do
        if [[ ! $i == *","* ]];then
            i=$i,0
        fi
        decimal="${i#*","}"
        if [[ $DECIMALS -lt ${#decimal} ]];then
            DECIMALS=${#decimal}
        fi
    done
    #now we trully process the numbers
    for i in $@
    do
        nflag=0
        if [[ ! $i == *","* ]];then
            i=$i,0
        fi
        integer="${i%%","*}"
        decimal="${i#*","}"
        if [[ $integer -lt 0 ]];then
            (( integer *= -1 ))
            nflag=1
        fi
        number=$integer$decimal
        if [[ $DECIMALS -gt ${#number} ]];then
            adjust=$(( $DECIMALS - ${#decimal} ))
            (( number *= $(fpow 10 $adjust) ))
        fi
        if [[ $nflag -eq 1 ]];then
            (( number *= -1  ))
        fi
        (( pre_result += number ))
        (( count++ ))
    done
    DECIMALS=$(( ${#pre_result} - $DECIMALS ))
    for (( i=1; i<=${#pre_result};i++ ))
    do
        result+=${pre_result:(( $i -1 )):1}
        if [[ $i -eq $DECIMALS ]];then
            result+=","
        fi
    done
    echo $result
}

## can multiply ints and floats and will return a float.
function mult_float(){
    DECIMALS=0
    count=1
    pre_result=1
    for i in $@
    do
        # bash fails when multiplying numbers longer than 11 digits
        # so we adjust accordingly
        if [[ ${#i} -gt 10 ]];then 
            deleted=$((  ${#i} - 10 ))
               i=${i::-$deleted}
        fi
        if [[ ! $i == *","* ]];then
            i=$i,0
        fi
        number=${i//,}
        decimal="${i#*","}"
        (( DECIMALS += ${#decimal} ))
        (( pre_result *= $number ))
        (( count++ ))
    done
    DECIMALS=$(( ${#pre_result} - $DECIMALS ))
    for (( i=1; i<=${#pre_result};i++ ))
    do
        result+=${pre_result:(( $i -1 )):1}
        if [[ $i -eq $DECIMALS ]];then
            result+=","
        fi
    done
    echo $result
}


## divides 2 ints or floats ($1/$2) and returns a float
function div_float(){
    if [[ ${#@} -gt 2 ]];then
        echo "too many arguments, function takes 2 arguments"
        exit 1
    elif [[ ${#@} -lt 2 ]];then
        echo "too few arguments, function takes 2 arguments"
        exit 1
    fi

    comma=0
    result=
    trail_zero=
    remain=0
    DECIMALS=0
    value=1
    count=1
    #just like in sum_float we need to now the quantity of decimals
    #before anything else
    for i in $@
    do
        #if we pass 2 int DECIMALS default to 1 for further processing
        if [[ $i == *","* ]];then
            decimal="${i#*","}"
            if [[ $DECIMALS -lt ${#decimal} ]];then
                    DECIMALS=${#decimal}
            fi
        fi 
    done

    ##preprocess the numbers
    for i in $@
    do
        if [[ ! $i == *","* ]];then
            i=$i,0
        fi
        decimal="${i#*","}"
        number=${i//,}
        if [[ $number -lt 0 ]];then
            (( value *= -1 ))
            (( number *= -1 ))
        fi
        if [[ $DECIMALS -gt ${#number} ]];then
            adjust=$(( $DECIMALS - ${#decimal} ))
            (( number *= $(fpow 10 $adjust) ))
        fi
        declare number${count}=$number
        (( count++ ))
    done
    #division algorithm, up to 10 steps, kinda shitty but i like it
    for (( i=1; i<=10; i++ ))
    do 
        #structure:
        #$number1 / $number2 = $result
        #$remain
        div=$(( number1 / number2 )) 
        #echo "$div | $number1 / $number2"
        if [[ $div -eq 0 ]];then
            # if comma is not set and result is empty
            if [[ $comma -eq 0 ]] && [[ -z $result ]] ;then
                result="$result"0,
                comma=1
                (( number1 *= 10 ))
            # if comma is not set and result is not empty
            elif [[ $comma -eq 0 ]] && [[ ! -z $result ]] ;then
                result="$result",
                comma=1
                (( number1 *= 10 ))
            else
            # if comma is set
                if [[ $remain -eq 0 ]];then
                    result="$result"0
                    (( number1 *= 10 ))
                else
                    (( number1 *= 10 ))
                fi 
                remain=0
            fi
        else
            remain=$div
            number1=$(( number1 - ( number2 * div ) ))
            result=$result$div
        fi
        # if the number1 equals 0 then we reached the end of the divsion
        if [[ $number1 -eq 0 ]];then
            break
        fi
    done
    if [[ $value -eq -1 ]];then
        result=-"$result"
    fi
    echo $result
   
}



