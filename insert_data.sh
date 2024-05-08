#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# loop the games
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # if winner is not equal to string 'winner' and opponent is not equal to string 'opponent'
  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
    then
      # The number of times winning team has appeared on the table
      WINNER_OCCURENCE=$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$WINNER'")

      # If winning team did not appeared before, insert it to the teams table
      if [[ $WINNER_OCCURENCE = 0 ]]
        then
          $PSQL "INSERT INTO teams(name) values('$WINNER')"
      fi

      # The number of times opponent team has appeared on the table
      OPPONENT_OCCURENCE=$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$OPPONENT'")

      # If opponent team did not appeared before, insert it to the teams table
      if [[ $OPPONENT_OCCURENCE = 0 ]]
        then
          $PSQL "INSERT INTO teams(name) values('$OPPONENT')"
      fi

      # get winner and opponent ids
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      # insert match informations
      $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')"
  fi
done