#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))

echo "Enter your username:"
read USER_NAME

USER_DATA=$($PSQL "SELECT games_played, best_game_played FROM users WHERE name='$USER_NAME'")

if [[ -z $USER_DATA ]]; then
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
  TEST=$($PSQL "INSERT INTO users(name, games_played) VALUES('$USER_NAME', 0);")
  USER_BEST_GAME=1000
  USER_GAMES_PLAYED=0
else
  IFS="|" read USER_GAMES_PLAYED USER_BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USER_NAME! You have played $USER_GAMES_PLAYED games, and your best game took $USER_BEST_GAME guesses."
fi

GUESSES=0
GUESSED_NUMBER=-1
RE_INT='^[0-9]+$'

echo "Guess the secret number between 1 and 1000:"

while [[ $RANDOM_NUMBER -ne $GUESSED_NUMBER ]]; do
  read GUESSED_NUMBER
  
  if ! [[ $GUESSED_NUMBER =~ $RE_INT ]]; then
    echo "That is not an integer, guess again:"
  else
    ((GUESSES++))
    if [[ $GUESSED_NUMBER -lt $RANDOM_NUMBER ]]; then
      echo "It's higher than that, guess again:"
    elif [[ $GUESSED_NUMBER -gt $RANDOM_NUMBER ]]; then
      echo "It's lower than that, guess again:"
    fi
  fi
done

echo "You guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"

# HIER WAR DER FEHLER: Die Klammern sind jetzt weg.
TEST2=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE name='$USER_NAME';")

if [[ -z $USER_BEST_GAME ]] || [[ $GUESSES -lt $USER_BEST_GAME ]]; then
  TEST3=$($PSQL "UPDATE users SET best_game_played=$GUESSES WHERE name='$USER_NAME';")
fi