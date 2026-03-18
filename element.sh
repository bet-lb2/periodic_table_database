if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ [0-9]+ ]]
then
  ELEMENT_LIST=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1;")
fi

if [[ $1 =~ [A-Z][a-z]* ]]
then
  ELEMENT_LIST=$($PSQL "SELECT * FROM elements WHERE symbol = '$1';")
fi

if [[ $1 =~ ^[A-Z][a-z][a-z]+ ]]
then
  ELEMENT_LIST=$($PSQL "SELECT * FROM elements WHERE name = '$1';")
fi

if [[ -z $ELEMENT_LIST ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

echo $ELEMENT_LIST | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
do
  # echo $ATOMIC_NUMBER
  PROPERTY_LIST=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
  echo $PROPERTY_LIST | while IFS='|' read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID
  do
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
done
