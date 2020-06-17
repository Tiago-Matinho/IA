%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-dynamic(estado_inicial/1).
:-dynamic(jogador/1).


%estado_inicial([0, 0, [4,4,4,4,4,4,4,4,4,4,4,4]]).
%jogador(p1).


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
valor([X|_], 1) :- X @> 24.
valor([X|_], -1) :- X @> 24.
valor(_, 0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                           DISTRIBUIR E CAPTURAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


soma_a_lista([], _, []).
soma_a_lista(L, 0, L).
soma_a_lista([H1|T1], X, [H2|T2]) :-
    H2 is H1 + X,
    soma_a_lista(T1, X, T2).

soma_resto(L, 0, L).
soma_resto([H|T1], R, [H1|T2]) :-
    H1 is H + 1,
    R1 is R - 1,
    soma_resto(T1, R1, T2),!.


% A B C D E F G H I J K L

% B C D E F G H I J K L
% C D E F G H I J K L A
% D E F G H I J K L A B
% E F G H I J K L A B C
% F G H I J K L A B C D
% G H I J K L A B C D E
% H I J K L A B C D E F
% I J K L A B C D E F G
% J K L A B C D E F G H
% K L A B C D E F G H I
% L A B C D E F G H I J
% A B C D E F G H I J K

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
insere_zero([C,D,E,F,G,H,I,J,K,L,A], 2,  [A,0,C,D,E,F,G,H,I,J,K,L]).
insere_zero([D,E,F,G,H,I,J,K,L,A,B], 3,  [A,B,0,D,E,F,G,H,I,J,K,L]).
insere_zero([E,F,G,H,I,J,K,L,A,B,C], 4,  [A,B,C,0,E,F,G,H,I,J,K,L]).
insere_zero([F,G,H,I,J,K,L,A,B,C,D], 5,  [A,B,C,D,0,F,G,H,I,J,K,L]).
insere_zero([G,H,I,J,K,L,A,B,C,D,E], 6,  [A,B,C,D,E,0,G,H,I,J,K,L]).
insere_zero([H,I,J,K,L,A,B,C,D,E,F], 7,  [A,B,C,D,E,F,0,H,I,J,K,L]).
insere_zero([I,J,K,L,A,B,C,D,E,F,G], 8,  [A,B,C,D,E,F,G,0,I,J,K,L]).
insere_zero([J,K,L,A,B,C,D,E,F,G,H], 9,  [A,B,C,D,E,F,G,H,0,J,K,L]).
insere_zero([K,L,A,B,C,D,E,F,G,H,I], 10, [A,B,C,D,E,F,G,H,I,0,K,L]).
insere_zero([L,A,B,C,D,E,F,G,H,I,J], 11, [A,B,C,D,E,F,G,H,I,J,0,L]).
insere_zero([A,B,C,D,E,F,G,H,I,J,K], 12, [A,B,C,D,E,F,G,H,I,J,K,0]).


ultima(X, Resto, U) :-
    Soma is X + Resto,
    U is mod(Soma, 12),
    U \= 0.
ultima(_, _, 12).

distribui([P1, P2, Tb], Pos, [P1, P2, Tbn], U) :-
    nth1(Pos, Tb, Val),
    dividir(Tb, Pos, A),
    Q is div(Val, 11),
    R is mod(Val, 11),
    ultima(Pos, R, U),
    soma_a_lista(A, Q, B),
    soma_resto(B, R, C),
    insere_zero(C, Pos, Tbn),!.

% A B C D E F | G H I J K L

% A L K J I H G F E D C B
% B A L K J I H G F E D C
% C B A L K J I H G F E D
% D C B A L K J I H G F E
% E D C B A L K J I H G F
% F E D C B A L K J I H G
% G F E D C B A L K J I H
% H G F E D C B A L K J I
% I H G F E D C B A L K J
% J I H G F E D C B A L K
% K J I H G F E D C B A L
% L K J I H G F E D C B A

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
captura_aux([X|T1], P, [0|T2]) :- 
    captura_aux(T1, A, T2),
    P is X + A.

captura([P1, P2, Tab], X, U, [P1n, P2, Tabn]) :-
    X @=< 6,
    U @> 6,
    inverte(Tab, U, A),
    captura_aux(A, P, B),
    P1n is P1 + P,
    inverte(Tabn, U, B),!.
captura([P1, P2, Tab], X, U, [P1, P2n, Tabn]) :-
    X @> 6,
    U @=< 6,
    inverte(Tab, U, A),
    captura_aux(A, P, B),
    P2n is P2 + P,
    inverte(Tabn, U, B),!.
captura(E, _, _, E).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               EXECUTA JOGADAS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tab_1([A,B,C,D,E,F|_], [A,B,C,D,E,F]).
tab_2([_,_,_,_,_,_|T], T).


jogada_1([P1,P2,Tabi], X, Ef) :-
    tab_1(Tabi, L1),
    maximo(L1, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),
    captura(En, X, U, Ef),!.
jogada_1([P1,P2,Tabi], X, Ef) :-
    tab_1(Tabi, L1),
    maximo(L1, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U),
    captura(En, X, U, Ef),!.

jogada_2([P1,P2,Tabi], X, Ef) :-
    tab_2(Tabi, L2),
    maximo(L2, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),
    captura(En, X, U, Ef),!.
jogada_2([P1,P2,Tabi], X, Ef) :-
    tab_2(Tabi, L2),
    maximo(L2, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U),
    captura(En, X, U, Ef),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                 OPERACOES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% X = 1
op([P1, P2, Tab], p1, 1, En) :-
    %write(1),nl,
    jogada_1([P1, P2, Tab], 1, En).
% X = 2
op([P1, P2, Tab], p1, 2, En) :-
    %write(2),nl,
    jogada_1([P1, P2, Tab], 2, En).
% X = 3
op([P1, P2, Tab], p1, 3, En) :-
    %write(3),nl,
    jogada_1([P1, P2, Tab], 3, En).
% X = 4
op([P1, P2, Tab], p1, 4, En) :-
    %write(4),nl,
    jogada_1([P1, P2, Tab], 4, En).
% X = 5
op([P1, P2, Tab], p1, 5, En) :-
    %write(5),nl,
    jogada_1([P1, P2, Tab], 5, En).
% X = 6
op([P1, P2, Tab], p1, 6, En) :-
    %write(6),nl,
    jogada_1([P1, P2, Tab], 6, En).
% X = 7
op([P1, P2, Tab], p2, 7, En) :-
    %write(7),nl,
    jogada_2([P1, P2, Tab], 7, En).
% X = 8
op([P1, P2, Tab], p2, 8, En) :-
    %write(8),nl,
    jogada_2([P1, P2, Tab], 8, En).
% X = 9
op([P1, P2, Tab], p2, 9, En) :-
    %write(9),nl,
    jogada_2([P1, P2, Tab], 9, En).
% X = 10
op([P1, P2, Tab], p2, 10, En) :-
    %write(10),nl,
    jogada_2([P1, P2, Tab], 10, En).
% X = 11
op([P1, P2, Tab], p2, 11, En) :-
    %write(11),nl,
    jogada_2([P1, P2, Tab], 11, En).
% X = 12
op([P1, P2, Tab], p2, 12, En) :-
    %write(12),nl,
    jogada_2([P1, P2, Tab], 12, En).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


oper(Ei, J, X, En) :-
    op(Ei, J, X, En).