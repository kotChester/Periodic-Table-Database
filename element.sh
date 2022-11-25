#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    CTR=0
    
    if [[ $1 =~ ^[0-9]+$ ]];
    then
        RETURN=$($PSQL "select * from elements where atomic_number=$1")
        CTR=1
    fi
    
    if [[ -z $RETURN ]]
    then
        RETURN=$($PSQL "select * from elements where symbol='$1'")
        CTR=2
    fi
    
    if [[ -z $RETURN ]]
    then
        RETURN=$($PSQL "select * from elements where name='$1'")
        CTR=3
    fi
    
    if [[ -z $RETURN ]]
    then
        CTR=0
    fi
    
    case $CTR in
        0)
        echo "I could not find that element in the database." ;;
        1)
            FEED=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number=$1");
            echo $FEED | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_P BAR BOIL_P
            do
                echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius.";
            done
        ;;
        2)
            FEED=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where symbol='$1'");
            echo $FEED | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_P BAR BOIL_P
            do
                echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius.";
            done
        ;;
        3)
            FEED=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name='$1'");
            echo $FEED | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_P BAR BOIL_P
            do
                echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius.";
            done
        ;;
    esac
    
fi
