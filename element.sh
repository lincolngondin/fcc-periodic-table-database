#!/bin/bash

# PSQL Variable to access database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Main logic here
if [[ $1 ]]
then
  # check if number
  SQL_QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE"
  ATOMIC_NUMBER=$(echo $1 | sed -r 's/^[0-9]*$//')
  if [[ -z $ATOMIC_NUMBER ]]
  then
    # is an atomic number
    CONDITION="atomic_number=$1"
  else
    # check if symbol (check size if less than 3 is an symbol)
    INPUT_SIZE=$(echo $1 | wc -m)
    if [[ $INPUT_SIZE -le 3 ]]
    then
      CONDITION="symbol='$1'"
    else
      CONDITION="name='$1'"
    fi
  fi
  ELEMENT=$($PSQL "$SQL_QUERY $CONDITION")
  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    echo "$ELEMENT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
  echo Please provide an element as an argument.
fi