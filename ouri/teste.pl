%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-dynamic(estado_inicial/1).
:dynamic(jogador/1).


estado_inicial([P1, P2, [4,4,4,4,4,4,4,4,4,4,4,4]]).
jogador(p1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                           TERMINAL E VALORES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REGRAS BASE
terminal([X|_]) :-
    X @> 24.
terminal([_, X| _]) :-
    X @> 24.


% VALORES
valor([X|_], 1000) :- X @> 24, jogador(p1).
valor([_,X|_], 1000) :- X @> 24, jogador(p2).
valor([X|_], -1000) :- X @> 24, jogador(p2).
valor([_,X|_], -1000) :- X @> 24, jogador(p2).
valor(_, 0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                           DISTRIBUIR E CAPTURAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


soma_a_lista([], _, []).
soma_a_lista([H1|T1], X, [H2|T2]) :-
    H2 is H1 + X,
    soma_a_lista(T1, X, T2).

soma_resto(L, 0, L).
soma_resto([H|T1], R, [H1|T2]) :-
    H1 is H + 1,
    R1 is R - 1,
    soma_resto(T1, R1, T2).


% 1 2 3 4 5 6 7 8 9 10 11 12

% 2 3 4 5 6 7 8 9 10 11 12
% 3 4 5 6 7 8 9 10 11 12 1
% 4 5 6 7 8 9 10 11 12 1 2
% 5 6 7 8 9 10 11 12 1 2 3
% 6 7 8 9 10 11 12 1 2 3 4
% 7 8 9 10 11 12 1 2 3 4 5
% 8 9 10 11 12 1 2 3 4 5 6
% 9 10 11 12 1 2 3 4 5 6 7
% 10 11 12 1 2 3 4 5 6 7 8
% 11 12 1 2 3 4 5 6 7 8 9
% 12 1 2 3 4 5 6 7 8 9 10
% 1 2 3 4 5 6 7 8 9 10 11

dividir([_,B,C,D,E,F,G,H,I,J,K,L], 1,  [B,C,D,E,F,G,H,I,J,K,L]).
dividir([A,_,C,D,E,F,G,H,I,J,K,L], 2,  [C,D,E,F,G,H,I,J,K,L,A]).
dividir([A,B,_,D,E,F,G,H,I,J,K,L], 3,  [D,E,F,G,H,I,J,K,L,A,B]).
dividir([A,B,C,_,E,F,G,H,I,J,K,L], 4,  [E,F,G,H,I,J,K,L,A,B,C]).
dividir([A,B,C,D,_,F,G,H,I,J,K,L], 5,  [F,G,H,I,J,K,L,A,B,C,D]).
dividir([A,B,C,D,E,_,G,H,I,J,K,L], 6,  [G,H,I,J,K,L,A,B,C,D,E]).
dividir([A,B,C,D,E,F,_,H,I,J,K,L], 7,  [H,I,J,K,L,A,B,C,D,E,F]).
dividir([A,B,C,D,E,F,G,_,I,J,K,L], 8,  [I,J,K,L,A,B,C,D,E,F,G]).
dividir([A,B,C,D,E,F,G,H,_,J,K,L], 9,  [J,K,L,A,B,C,D,E,F,G,H]).
dividir([A,B,C,D,E,F,G,H,I,_,K,L], 10, [K,L,A,B,C,D,E,F,G,H,I]).
dividir([A,B,C,D,E,F,G,H,I,J,_,L], 11, [L,A,B,C,D,E,F,G,H,I,J]).
dividir([A,B,C,D,E,F,G,H,I,J,K,_], 12, [A,B,C,D,E,F,G,H,I,J,K]).

insere_zero([B,C,D,E,F,G,H,I,J,K,L], 1,  [0,B,C,D,E,F,G,H,I,J,K,L]).
insere_zero([A,C,D,E,F,G,H,I,J,K,L], 2,  [A,0,C,D,E,F,G,H,I,J,K,L]).
insere_zero([A,B,D,E,F,G,H,I,J,K,L], 3,  [A,B,0,D,E,F,G,H,I,J,K,L]).
insere_zero([A,B,C,E,F,G,H,I,J,K,L], 4,  [A,B,C,0,E,F,G,H,I,J,K,L]).
insere_zero([A,B,C,D,F,G,H,I,J,K,L], 5,  [A,B,C,D,0,F,G,H,I,J,K,L]).
insere_zero([A,B,C,D,E,G,H,I,J,K,L], 6,  [A,B,C,D,E,0,G,H,I,J,K,L]).
insere_zero([A,B,C,D,E,F,H,I,J,K,L], 7,  [A,B,C,D,E,F,0,H,I,J,K,L]).
insere_zero([A,B,C,D,E,F,G,I,J,K,L], 8,  [A,B,C,D,E,F,G,0,I,J,K,L]).
insere_zero([A,B,C,D,E,F,G,H,J,K,L], 9,  [A,B,C,D,E,F,G,H,0,J,K,L]).
insere_zero([A,B,C,D,E,F,G,H,I,K,L], 10, [A,B,C,D,E,F,G,H,I,0,K,L]).
insere_zero([A,B,C,D,E,F,G,H,I,J,L], 11, [A,B,C,D,E,F,G,H,I,J,0,L]).
insere_zero([A,B,C,D,E,F,G,H,I,J,K], 12, [A,B,C,D,E,F,G,H,I,J,K,0]).

ultima(X, Resto, 12) :-
    Soma is X + Resto,
    0 is mod(Soma, 12).
ultima(X, Resto, U) :-
    Soma is X + Resto,
    U is mod(Soma, 12).

distribui([P1, P2, Tb], Pos, [P1, P2, Tbn], U) :-
    nth1(Pos, Tb, Val),
    dividir(Tb, Pos, A),
    Q is div(Val, 11),
    R is mod(Val, 11),
    ultima(Pos, R, U),
    soma_a_lista(A, Q, B),
    soma_resto(B, R, C),
    insere_zero(C, Pos, Tbn).

% 1 2 3 4 5 6 | 7 8 9 10 11 12

% 1 12 11 10 9 8 7 6 5 4 3 2
% 2 1 12 11 10 9 8 7 6 5 4 3
% 3 2 1 12 11 10 9 8 7 6 5 4
% 4 3 2 1 12 11 10 9 8 7 6 5
% 5 4 3 2 1 12 11 10 9 8 7 6
% 6 5 4 3 2 1 12 11 10 9 8 7
% 7 6 5 4 3 2 1 12 11 10 9 8
% 8 7 6 5 4 3 2 1 12 11 10 9
% 9 8 7 6 5 4 3 2 1 12 11 10
% 10 9 8 7 6 5 4 3 2 1 12 11
% 11 10 9 8 7 6 5 4 3 2 1 12
% 12 11 10 9 8 7 6 5 4 3 2 1

inverte([A,B,C,D,E,F,G,H,I,J,K,L], 1,  [A,L,K,J,I,H,G,F,E,D,C,B]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 2,  [B,A,L,K,J,I,H,G,F,E,D,C]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 3,  [C,B,A,L,K,J,I,H,G,F,E,D]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 4,  [D,C,B,A,L,K,J,I,H,G,F,E]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 5,  [E,D,C,B,A,L,K,J,I,H,G,F]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 6,  [F,E,D,C,B,A,L,K,J,I,H,G]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 7,  [G,F,E,D,C,B,A,L,K,J,I,H]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 8,  [H,G,F,E,D,C,B,A,L,K,J,I]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 9,  [I,H,G,F,E,D,C,B,A,L,K,J]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 10, [J,I,H,G,F,E,D,C,B,A,L,K]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 11, [K,J,I,H,G,F,E,D,C,B,A,L]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 12, [L,K,J,I,H,G,F,E,D,C,B,A]).

captura_aux([], 0, []).
captura_aux([0|T], 0, [0|T]).
captura_aux([X|T], 0, [X|T]) :- X @> 3.
captura_aux([X|T], P, [0|T]) :- 
    captura_aux(T, A),
    P is X + A.

captura([P1, P2, Tab], U, [P1, P2, Tabn], P) :-
    inverte(Tab, U, A),
    captura_aux(A, P, Tabn).

calcula_pontos([P1, P2, Tab], Pos, [P1n, P2, Tabn]) :-
    Pos @< 6,!,
    distribui([P1, P2, Tab], Pos, A, U),
    captura(A, U, [_, _, Tabn], P),
    P1n is P1 + P.
calcula_pontos([P1, P2, Tab], Pos, [P1, P2n, Tabn]) :-
    distribui([P1, P2, Tab], Pos, A, U),
    captura(A, U, [_, _, Tabn], P),
    P2n is P2 + P.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               VALIDAR JOGADAS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tab_1([A,B,C,D,E,F|_], [A,B,C,D,E,F]).
tab_2([A,B,C,D,E,F|T], T).

% verifica se a jogada e valida
jogada_valida_aux(Tab, X, M) :-
    M @> 1,!,
    nth1(Tab, X, Val),
    Val @> 1.
jogada_valida_aux(Tab, X, 1) :-
    nth1(Tab, X, 1).

% verifica para o lado do primeiro jogador
jogada_valida_1(Tab, X) :-
    tab_1(Tab, Tab1),
    maximo(Tab1, M),
    jogada_valida_aux(Tab1, X, M).

% verifica para o lado do segundo jogador
jogada_valida_2(Tab, X) :-
    tab_2(Tab, Tab2),
    maximo(Tab2, M),
    jogada_valida_aux(Tab2, X, M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                 OPERACOES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% X = 1
oper([P1, P2, Tab], p1, 1, En) :-
    jogada_valida_1(Tab, 1),!,
    calcula_pontos([P1, P2, Tab], 1, En).
% X = 2
oper([P1, P2, Tab], p, 2, En) :-
    jogada_valida_1(Tab, 2),!,
    calcula_pontos([P1, P2, Tab], 2, En).
% X = 1
oper([P1, P2, Tab], p, 1, En) :-
    jogada_valida_1(Tab, 1),!,
    calcula_pontos([P1, P2, Tab], 1, En).
% X = 1
oper([P1, P2, Tab], p, 1, En) :-
    jogada_valida_1(Tab, 1),!,
    calcula_pontos([P1, P2, Tab], 1, En).
% X = 1
oper([P1, P2, Tab], p, 1, En) :-
    jogada_valida_1(Tab, 1),!,
    calcula_pontos([P1, P2, Tab], 1, En).
% X = 1
oper([P1, P2, Tab], p, 1, En) :-
    jogada_valida_1(Tab, 1),!,
    calcula_pontos([P1, P2, Tab], 1, En).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%