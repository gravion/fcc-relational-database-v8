#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# MAKE SCRIPTS EXECUTABLE chmod + x <file>

# creating database not allowed :(
# psql --username=freecodecamp --dbname=postgres -t --no-align -c "CREATE DATABASE IF NOT EXISTS worldcup;"
$PSQL "DROP TABLE IF EXISTS games, teams CASCADE"
# creating the tables
$PSQL "CREATE TABLE teams( \
    team_id SERIAL PRIMARY KEY, \
    name VARCHAR(30) NOT NULL UNIQUE \
    );"
$PSQL "CREATE TABLE games( \
    game_id SERIAL PRIMARY KEY, \
    year INT NOT NULL, \
    round VARCHAR(30) NOT NULL, \
    winner_id INT NOT NULL REFERENCES teams(team_id), \
    opponent_id INT NOT NULL REFERENCES teams(team_id), \
    winner_goals INT NOT NULL, \
    opponent_goals INT NOT NULL \
    );"

cat games.csv | while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR == 'year' ]]; then
  WINNER_IN_TABLE=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER_NAME';")
  if [[ -z $WINNER_IN_TABLE ]]; then
    $PSQL "INSERT INTO teams(name) VALUES ('$WINNER_NAME');"
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER_NAME';")
  echo "$WINNER_ID"
  OPPONENT_IN_TABLE=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT_NAME';")
  if [[ -z $OPPONENT_IN_TABLE ]]; then
    $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT_NAME');"
  fi
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT_NAME';")
  echo "$OPPONENT_ID"
  GAME_IN_TABLE=$($PSQL "SELECT game_id FROM games WHERE winner_id = $WINNER_ID AND opponent_id = $OPPONENT_ID;")
  if [[ -z $GAME_IN_TABLE ]]; then
    $PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES \
      ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);"
  fi
  fi
done

# validation
TEAMS_COUNT=$($PSQL "SELECT COUNT(*) FROM teams;")
GAMES_COUNT=$($PSQL "SELECT COUNT(*) FROM games;")
echo -e "\n$TEAMS_COUNT/24 teams and $GAMES_COUNT/32 games present in the database."
