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

function process_floats(){

loop=1
    for i in "$@"
    do
        ## if any is a negative number
        if [[ $i == *"-"* ]];then
            declare int${loop}_n=1
        fi
        ##pre-processing the first number
        if [[ "$i" == *","* ]];then
            declare float${loop}_int=$(echo $i | cut -d',' -f1)
            declare float${loop}_dec=$(echo $i | cut -d',' -f2)
        elif [[ "$i" == *"."* ]];then
            declare float${loop}_int=$(echo $i | cut -d'.' -f1)
            declare float${loop}_dec=$(echo $i | cut -d'.' -f2)
        else
            declare float${loop}_int=$i
            declare float${loop}_dec=0
        fi
        
         (( loop+=1 ))
    done
    
    #stop the loop to count de decimal parts on each number
    #and single number operations
    DECIMALS=${#float1_dec}
    if [[ ${#float1_dec} -le ${#float2_dec} ]];then
        DECIMALS=${#float2_dec}
    fi
    #for easier processing we join the int and dec parts and 
    #fill any necessary spots with zeroes
    if [[ ${#float1_dec} -lt ${#float2_dec} ]];then
        num_to_add=$(( ${#float2_dec} - ${#float1_dec} ))
        for (( i=0; i<$num_to_add; i++ ))
        do
            float1_dec="$float1_dec"0
        done
    fi
    if [[ ${#float2_dec} -lt ${#float1_dec} ]];then
        num_to_add=$(( ${#float1_dec} - ${#float2_dec} ))
        for (( i=0; i<$num_to_add; i++ ))
        do
            float2_dec="$float2_dec"0
        done
        
    fi
    ##decimals are normalized, let's join the numbers into 1
    whole_num_1=$float1_int$float1_dec
    whole_num_2=$float2_int$float2_dec

    echo "$whole_num_1|$whole_num_2|$int1_n|$int2_n|$DECIMALS"
}


# this is hacky as hell but it works
# can add non floats and will return a float
# add or substract 2 floats
# if a single int is given it will return a float

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
        integer="${i%%","*}"
        decimal="${i#*","}"
        (( DECIMALS += ${#decimal} ))
        (( pre_result *= $integer$decimal ))
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
    
    int1_n=1
    int2_n=1   
    DECIMALS=0

    return=$(process_floats $1 $2)
    
    whole_num_1=$( echo $return | cut -d'|' -f1 )
    whole_num_2=$( echo $return | cut -d'|' -f2 )
    int1_n=$( echo $return | cut -d'|' -f3 )
    int2_n=$( echo $return | cut -d'|' -f4 )
    DECIMALS=$( echo $return | cut -d'|' -f5 )

    ######## both numbers are  preporcessed	
        
    if [[ $int1_n -lt 0 ]];then
        (( whole_num_1 *= -1 ))
    fi
    if [[ $int2_n -lt 0 ]];then
        (( whole_num_2 *= -1 ))
    fi

    comma=0
    result=
    first=$whole_num_1
    second=$whole_num_2
    remain=0
    trail_zero=
    for (( i=1; i<=10; i++ ))
    do 
        #"$first / $second = $result"
        #"$remain"
        div=$(( $first / $second ))
        if [[ $div -eq 0 ]];then
            if [[ $comma -eq 0 ]];then
                result="$result"0,
                comma=1
                (( first *= 10 ))
            else
                if [[ $remain -eq 0 ]];then
                    result="$result"0
                    (( first *= 10 ))
                else
                    (( first *= 10 ))
                fi 
                remain=0
            fi
        else
        remain=$div
        first=$(( first - ( $second * div ) ))
        result=$result$div
        fi
        if [[ $first -eq 0 ]];then
            break
        fi

    done
    if [[ $value -lt 0 ]];then
        result=-"$result"
    fi
    echo $result
   
}


