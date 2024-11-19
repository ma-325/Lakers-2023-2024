
WITH Game_Stats AS (
    SELECT 
        opponent,
        result,
        lakers_score,
        opponent_score,
        OT, 
        CASE 
            WHEN result = 'W' THEN 1 ELSE 0 
        END AS win_flag,
        CASE 
            WHEN result = 'L' THEN 1 ELSE 0 
        END AS loss_flag,
        CASE 
            WHEN OT LIKE '%OT%' THEN 1 ELSE 0 
        END AS ot_flag,
        (lakers_score - opponent_score) AS point_difference
    FROM Lakers_Games
),
Win_Loss_Summary AS (
    SELECT 
        opponent,
        SUM(win_flag) AS total_wins,
        SUM(loss_flag) AS total_losses,
        SUM(ot_flag) AS total_ot_games,
        AVG(lakers_score) AS avg_lakers_score,
        AVG(opponent_score) AS avg_opponent_score,
        AVG(point_difference) AS avg_point_difference
    FROM Game_Stats
    GROUP BY opponent
),
Streaks AS (
    SELECT 
        opponent,
        result,
        COUNT(*) AS streak_length,
        ROW_NUMBER() OVER (PARTITION BY opponent, result ORDER BY COUNT(*) DESC) AS streak_rank
    FROM (
        SELECT 
            opponent, 
            result, 
            ROW_NUMBER() OVER (PARTITION BY opponent ORDER BY game_date) -
            ROW_NUMBER() OVER (PARTITION BY opponent, result ORDER BY game_date) AS streak_group
        FROM Lakers_Games
    ) SubQuery
    GROUP BY opponent, result, streak_group
)
SELECT 
    wls.opponent AS "Opponent",
    wls.total_wins AS "Total Wins",
    wls.total_losses AS "Total Losses",
    ROUND(wls.avg_lakers_score, 2) AS "Lakers Avg Score",
    ROUND(wls.avg_opponent_score, 2) AS "Opponent Avg Score",
    ROUND(wls.avg_point_difference, 2) AS "Avg Point Difference",
    wls.total_ot_games AS "OT Games",
    MAX(CASE WHEN s.result = 'W' AND s.streak_rank = 1 THEN s.streak_length ELSE 0 END) AS "Longest Win Streak",
    MAX(CASE WHEN s.result = 'L' AND s.streak_rank = 1 THEN s.streak_length ELSE 0 END) AS "Longest Loss Streak"
FROM Win_Loss_Summary wls
LEFT JOIN Streaks s ON wls.opponent = s.opponent
GROUP BY wls.opponent, wls.total_wins, wls.total_losses, wls.avg_lakers_score, wls.avg_opponent_score, wls.avg_point_difference, wls.total_ot_games
ORDER BY "Opponent";
