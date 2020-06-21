jogador(P, p2) :- X is P mod 2, X = 0.
jogador(P, p1) :- X is P mod 2, X = 1.


valor([_,Y,_], 10) :- Y @> 24.
valor([X,_,_], -10) :- X @> 24.
valor([X,Y,_], 0) :- X @< 25, Y @< 25.