
CREATE TABLE Lakers_Games (
    game_number SERIAL primary KEY,          
    game_date TEXT,           
    start_time TEXT,          
    location TEXT,			 
    opponent TEXT,            
    result TEXT,              
    OT TEXT,				  
    lakers_score INT,        
    opponent_score INT,       
    total_wins INT,          
    total_losses INT,         
    streak TEXT,               
	Attend INT,				 
    Length TEXT 	
);
