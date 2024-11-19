/*
Change row 5 path to your own
*/

LOAD DATA INFILE 'Path' 
INTO TABLE Lakers_Games
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(game_number, game_date, start_time, location, opponent, result, OT, lakers_score, opponent_score, total_wins, total_losses, streak, Attend, Length);
