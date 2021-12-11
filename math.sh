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
    cnt=1
    if [[ $2 -gt 0 ]];then 
        for (( c=1; c<=$2; c++ ))
        do  
           (( cnt *= $1 ))
        done
    else
        exponent=$2
        exponent=$(( exponent *= -1 ))
        for (( c=1; c<=$exponent; c++ ))
        do  
           (( cnt *= $1 ))
        done
        cnt=$(div_float 1 $cnt)
        
    fi
    echo $cnt
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


## divides 2 ints ($1/$2) and returns a float
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
    remain=0
    trail_zero=
    DECIMALS=0
    value=1
    count=1
    #just like in sum_flaot we need to now the quantity of decimals
    #before anything else
    for i in $@
    do
        decimal="${i#*","}"
        if [[ $DECIMALS -lt ${#decimal} ]];then
                DECIMALS=${#decimal}
        fi
    done
    ##now we preprocess the numbers
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
    #division algorithm, up to 10 steps
    for (( i=1; i<=10; i++ ))
    do 
        #"$first / $second = $result"
        #"$remain"
        div=$(( number1 / number2 )) 
        if [[ $div -eq 0 ]];then
            if [[ $comma -eq 0 ]];then
                result="$result"0,
                comma=1
                (( number1 *= 10 ))
            else
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
        if [[ $number1 -eq 0 ]];then
            break
        fi
    done
    if [[ $value -eq -1 ]];then
        result=-"$result"
    fi
    echo $result
   
}


