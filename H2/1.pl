jogador(P, p1) :- X is P mod 2, X = 0.
jogador(P, p2) :- X is P mod 2, X = 1.


valor([X,Y,_], Z) :- X @> Y, Z is X - Y.
valor([X,Y,_], Z) :- Y @> X, Z is X - Y.
valor([X,Y,_], 0) :- X @< 25, Y @< 25.
