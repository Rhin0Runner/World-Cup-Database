#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

#truncate tables
echo $($PSQL "TRUNCATE TABLE games, teams")
#lets read the games.csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_G OPP_G

do
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then
      INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #verify if something was inserted
      if [[ $INSERT_INTO_TEAMS = 'INSERT 0 1' ]]
      then
        echo Inserted $WINNER into teams
      fi
    fi
  fi

  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ -z $TEAMS2 ]]
    then
      INSERT_INTO_TEAMS2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #verify if something was inserted
      if [[ $INSERT_INTO_TEAMS2 = 'INSERT 0 1' ]]
      then
        echo Inserted $OPPONENT into teams
      fi
    fi
  fi

  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $TEAM_ID_WINNER || -n $TEAM_ID_OPP ]]
  then
    if [[ $YEAR != 'year' ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPP, $WIN_G, $OPP_G)")
      if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
      then
        echo Inserted $YEAR into games
      fi
    fi
  fi
done
