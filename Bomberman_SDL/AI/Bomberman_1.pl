:- use_module(library(lists)).
:- use_module(library(random)).

% TODO: QUESTION: how we could declare enums??
% enum { -2 = -2, -1 = -1, nothing = 0,1 = 1,2 = 2, agent = 11, villain = 22,bomb = 33}
% enum AgentActions { left(3),right(4), up(1), down(2), put_bomb(5), no_action(0)}
% enum AgentStatus { alive(1), dead(0) }

:- dynamic
	world_size/2,
	world/3,
	agent_status/1.

have_bomb:-true.
	
foo(L) :-
	Z1 is 4, 
	Z2 is 3,
	L is [].
	
set_agent_status(Status) :-
	retractall(agent_status(_)),
	assert(agent_status(Status)),
	true.

agent_action(Action) :- 
	% TODO: Implement all logic here!
	Action = 0,
	true.
	
%villain_action(Action, VillainID) :- 
	% TODO: Optoinel! Implement all logic here!
%	Action = 0,
%	true.
	
door_loction(X, Y) :- 
	world(-1, X, Y),
	true.
	
agent_location(X, Y) :-
	world(11,X, Y),
	true.
	
set_agent_location(X, Y) :-
	% TODO: check if agent can be in (X, Y)
	not(world(1,X,Y)),not(world(2,X,Y)),    
	% dont take a look if agent could die going in (X, Y). 
	not(world(22,X,Y)),
	% It should be done in logic section. This is just a setter function
	retractall(world(0,X, Y)),
	assert(world(11,X, Y)),
	write(X), 
	write(Y),
	true.

% Could be combined with agent_location, if we want ...
villain_locaion(X, Y) :- 
	world(22, X, Y),
	true.
	
set_villain_location(X, Y) :-
	% TODO: check if villain can be in (X, Y)
	not(world(1,X,Y)),not(world(2,X,Y)),   
	% dont take a look if villain could die going in (X, Y). 
	% It should be done in logic section. This is just a setter function
	retractall(world(_,X, Y)),
	assert(world(22,X, Y)),   
	true.
	
% Add closed door location
add_wall(-1,X, Y) :- 
	world_size(W,H),
	X>=0, X < W, Y>=0,Y < H,
	% TODO: add assertion to check if there was a door inserted before
	not(world(-1, A, B)),
	% we could delete the previous door as an option
	% if we want to have single door in the world
	retractall(world(0, X, Y)),
	% add closed door
	assert(world(-1, X, Y)),
	% add destroable wall on top of the closed door
	assert(world(2, X, Y)),
	true .
	
% Add opened door location (after exploding the wall with the door)
add_wall(-2, X, Y) :-  
	world_size(W,H),
	X>=0, X < W, Y>=0,Y < H,
	% TODO: ensure that there is a door (world(X, Y, Z) and Z == -1 )
	world(-1, X, Y),
	retractall(world(0, X, Y)),
	assert(world(-2, X, Y)),
	true .

	
% Add notdestroable wall location
add_wall(1, X, Y) :-
	world_size(W,H),
	X>=0, X < W, Y>=0,Y < H,
	retractall(world(0, X, Y)),
	assert(world(1, X, Y)),
	true .
		
% Add destroable wall location
add_wall(2, X, Y) :-
	world_size(W,H),
	X>=0, X < W, Y>=0,Y < H,
	retractall(world(0, X, Y)),
	assert(world(2, X, Y)),
	true .


add_bomb(X,Y) :- have_bomb, world(agent,X,Y),
				assert(world(33,X,Y)).
				
set_bomb(X,Y) :- have_bomb, world(agent,X,Y),
				(world(2,X+1,Y);world(2,X+1,Y)).



walk(X,Y,3) :- 
	world_size(W,H),
	W1 is W - 1,
	X>=0, X < W1, Y>=0,Y < H,
	X1 is X + 1,
	Y1 is Y + 1,
	Y_1 is Y - 1,
	X2 is X + 2,
	X3 is X + 3,
	not(world(1, X1, Y)),
	not(world(2, X1, Y)),
	not(world(33, X1, Y)),not(world(33, X1, Y1)),
	not(world(33, X2, Y)),not(world(33, X1, Y_1)),
	not(world(33, X3, Y)),not(world(33, X1, Y_1)).

walk(X,Y,1) :- 
	world_size(W,H),
	X>0, X < W, Y>=0,Y < H,
	X_1 is X - 1,
	X_3 is X - 3,
	Y1 is Y + 1,
	Y_1 is Y - 1,
	X_2 is X - 2,
	X3 is X + 3,
	not(world(1, X_1, Y)),
	not(world(2, X_1, Y)),
	not(world(33, X_1, Y)),not(world(33, X_1, Y1)),
	not(world(33, X_1, Y_1)),not(world(33, X_2, Y)),
	not(world(33, X_3, Y)).

walk(X,Y,5) :- 
	world_size(W,H),
	X>=0, X < W, Y>0,Y < H,
	Y1 is Y + 1,
	Y2 is Y + 2,
	Y3 is Y + 3,
	X_1 is X - 1,
	X1 is X + 1,
	not(world(1, X, Y1)),
	not(world(2, X, Y1)),
	not(world(33, X, Y1)),not(world(33, X_1, Y1)),
	not(world(33, X1, Y1)),not(world(33, X, Y2)),
	not(world(33, X, Y3)).

walk(X,Y,2) :- 
	world_size(W,H),
	H1 is H - 1,
	X>=0, X < W, Y>=0,Y < H1,
	Y_1 is Y - 1,
	Y_2 is Y - 2,
	Y_3 is Y - 3,
	X_1 is X - 1,
	X1 is X + 1,
	not(world(1, X, Y_1)),
	not(world(2, X, Y_1)),
	not(world(33, X, Y_1)),not(world(33, X_1, Y_1)),
	not(world(33, X1, Y_1)),not(world(33, X, Y_2)),
	not(world(33, X, Y_3)).

	
init(W, H) :- 
	retractall(),
	assert(world_size(W, H)),
	% set agent_status to dead to avoid dieing at the wery beginning
	assert(agent_status(0)),
	true.
	
retractall() :- 
	retractall(world_size(_,_)),
	retractall(world(_,_,_)),
	retractall(agent_status(_)),
	true.