:-dynamic(estado_atual/3).
:-dynamic(jogada_possivel/1).
estado_atual(0, 0, [1,2,1,3,1,2,1,0,7,0,2,0]).

lado(e).

terminal(X, _, _, d) :-
    X @> 24.

terminal(_, X, _, e) :-
    X @> 24.

%% Tentar com o valor a 10 -10 ou 0

valor(X, _, _, X, e).

valor(_, X, _, X, d).

% retorna lista do lado esquerdo ou direito
lista_lado_d([A, B, C, D, E, F |_], [A, B, C, D, E, F]).
lista_lado_e([_, _, _, _, _, _ |T], T).

% manipulação de listas
lista_ate_x(_, 1, []).
lista_ate_x([H|T1], X, [H|T2]) :-
    X1 is X - 1,
    lista_ate_x(T1, X1, T2), !.

lista_a_partir_x(T, 0, T).
lista_a_partir_x([_|T1], X, T2) :-
    X1 is X - 1,
    lista_a_partir_x(T1, X1, T2), !.

% separa os lados que tem que adicionar as sementes
adiciona_x_lista(L, 0, L).
adiciona_x_lista([], _, []).
adiciona_x_lista([H|T1], X, [H1|T2]) :-
    H1 is H + X,
    adiciona_x_lista(T1, X, T2).

adiciona_resto(L, 0, L).
adiciona_resto([H|T1], N, [H1|T2]) :-
    H1 is H + 1,
    N1 is N - 1,
    adiciona_resto(T1, N1, T2).

adiciona(Li, N, Lf) :-
    Q is div(N, 11),
    adiciona_x_lista(Li, Q, Lf1),
    R is mod(N, 11),
    adiciona_resto(Lf1, R, Lf), !.

joga(Li, X, Lff, D1) :-
    X1 is X - 1,
    nth0(X1, Li, N),
    lista_a_partir_x(Li, X, A),
    lista_ate_x(Li, X, B),
    append(A, B, AB),
    adiciona(AB, N, Lf),
    D is 12 - X,
    D1 is D + 1,
    lista_a_partir_x(Lf, D, An),
    lista_ate_x(Lf, D1, Bn),
    append(An, [0], Ann),
    append(Ann, Bn, Lff), !.

%remove casas com menos que 2

%jogadas
