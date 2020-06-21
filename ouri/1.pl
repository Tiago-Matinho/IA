jogador(P, p1) :- X is P mod 2, X = 0.
jogador(P, p2) :- X is P mod 2, X = 1.


valor([X,Y,_], X) :- X @> Y.
valor([X,Y,_], -Y) :- Y @> X.
valor([X,Y,_], 0) :- X = Y.