#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

QUERY="SELECT atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name 
FROM properties 
INNER JOIN types USING(type_id) 
INNER JOIN elements USING(atomic_number) 
WHERE symbol='$1' OR name='$1' OR atomic_number::TEXT='$1';"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  ELEMENT_ROW=$($PSQL "$QUERY" )
  if [[ -z $ELEMENT_ROW ]]; then
    echo "I could not find that element in the database."
  else
    IFS='|' read ELEMENT_ATOMIC_NUMBER \
                 ELEMENT_TYPE \
                 ELEMENT_ATOMIC_MASS \
                 ELEMENT_MELTING_POINT_CELSIUS \
                 ELEMENT_BOILING_POINT_CELSIUS \
                 ELEMENT_SYMBOL \
                 ELEMENT_NAME \
                 <<< $ELEMENT_ROW

echo "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). \
It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. \
$ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT_CELSIUS celsius and a \
boiling point of $ELEMENT_BOILING_POINT_CELSIUS celsius."
  fi
fi

