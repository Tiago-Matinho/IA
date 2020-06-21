%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-dynamic(estado_inicial/1).
:-dynamic(jogador/1).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                   TERMINAL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REGRAS BASE
terminal([X,_,_]) :-
    X @> 24.
terminal([_, X, _]) :-
    X @> 24.
terminal([_,_,[0,0,0,0,0,0,0,0,0,0,0,0]]).
terminal([_,_,[1,0,0,0,0,0,1,0,0,0,0,0]]).
terminal([_,_,[0,1,0,0,0,0,0,1,0,0,0,0]]).
terminal([_,_,[0,0,1,0,0,0,0,0,1,0,0,0]]).
terminal([_,_,[0,0,0,1,0,0,0,0,0,1,0,0]]).
terminal([_,_,[0,0,0,0,1,0,0,0,0,0,1,0]]).
terminal([_,_,[0,0,0,0,0,1,0,0,0,0,0,1]]).


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


%
%A 				1
%B A 			2
%C B A 			3
%D C B A 		4
%E D C B A 		5
%F E D C B A 	6
%
%G				7
%H G			8
%I H G			9
%J I H G		10
%K J I H G		11
%L K J I H G 	12

captura_aux([], 0, []).
captura_aux([X|T], 0, [X|T]) :- X @< 2.
captura_aux([X|T], 0, [X|T]) :- X @> 3.
captura_aux([X|T1], P, [0|T2]) :-
    between(2, 3, X),
    captura_aux(T1, A, T2),
    P is X + A.


inverte([A|T], 1, [An|T], P) :- captura_aux([A], P, [An]).
inverte([A,B|T], 2, [An,Bn|T], P) :- captura_aux([B,A], P, [Bn,An]).
inverte([A,B,C|T], 3, [An,Bn,Cn|T], P) :- captura_aux([C,B,A], P, [Cn,Bn,An]).
inverte([A,B,C,D|T], 4, [An,Bn,Cn,Dn|T], P) :- captura_aux([D,C,B,A], P, [Dn,Cn,Bn,An]).
inverte([A,B,C,D,E|T], 5, [An,Bn,Cn,Dn,En|T], P) :- captura_aux([E,D,C,B,A], P, [En,Dn,Cn,Bn,An]).
inverte([A,B,C,D,E,F|T], 6, [An,Bn,Cn,Dn,En,Fn|T], P) :- captura_aux([F,E,D,C,B,A], P, [Fn,En,Dn,Cn,Bn,An]).
inverte([A,B,C,D,E,F,G|T], 7, [A,B,C,D,E,F,Gn|T], P) :- captura_aux([G], P, [Gn]).
inverte([A,B,C,D,E,F,G,H|T], 8, [A,B,C,D,E,F,Gn,Hn|T], P) :- captura_aux([H,G], P, [Hn,Gn]).
inverte([A,B,C,D,E,F,G,H,I|T], 9, [A,B,C,D,E,F,Gn,Hn,In|T], P) :- captura_aux([I,H,G], P, [In,Hn,Gn]).
inverte([A,B,C,D,E,F,G,H,I,J|T], 10, [A,B,C,D,E,F,Gn,Hn,In,Jn|T], P) :- captura_aux([J,I,H,G], P, [Jn,In,Hn,Gn]).
inverte([A,B,C,D,E,F,G,H,I,J,K|T], 11, [A,B,C,D,E,F,Gn,Hn,In,Jn,Kn|T], P) :- captura_aux([K,J,I,H,G], P, [Kn,Jn,In,Hn,Gn]).
inverte([A,B,C,D,E,F,G,H,I,J,K,L], 12, [A,B,C,D,E,F,Gn,Hn,In,Jn,Kn,Ln], P) :- captura_aux([L,K,J,I,H,G], P, [Ln,Kn,Jn,In,Hn,Gn]).


captura([P1, P2, Tab], X, U, [P1n, P2, Tabn]) :-
    X @=< 6,
    U @> 6,
    inverte(Tab, U, Tabn, P),
    P1n is P1 + P,!.
captura([P1, P2, Tab], X, U, [P1, P2n, Tabn]) :-
    X @> 6,
    U @=< 6,
    inverte(Tab, U, Tabn, P),
    P2n is P2 + P,!.
captura(E, _, _, E).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               EXECUTA JOGADAS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tab_1([A,B,C,D,E,F|_], [A,B,C,D,E,F]).
tab_2([_,_,_,_,_,_|T], T).


jogada_1(Ei, _, Ei) :-
    terminal(Ei),!.
%jogada_1 que verifica a regra suplementar 1 se aplica
jogada_1([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :-
    tab_2(Tabi, L2),
    maximo(L2, 0),          % O adversario nao tem como jogar (Regra supl 1)
    tab_1(Tabi, L1),        % Verifica se a jogada X é válida
    maximo(L1, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),  % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),
    tab_2(Tabn, L2n),
    \+ maximo(L2n, 0),!.        % A jogada introduz novas pecas no lado do adv
jogada_1([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :- % Repete-se o mesmo que na anterior mas para o caso de o valor maximo do nosso lado = 1
    tab_2(Tabi, L2),
    maximo(L2, 0),              % O adversario nao tem como jogar (Regra supl 1)
    tab_1(Tabi, L1),            % Verifica se a jogada X é válida
    maximo(L1, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U), % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),
    tab_2(Tabn, L2n),
    \+ maximo(L2n, 0),!.
jogada_1([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :-
    tab_1(Tabi, L1),        % Verifica se a jogada X é válida
    maximo(L1, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),  % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),!.
jogada_1([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :- % Repete-se o mesmo que na anterior mas para o caso de o valor maximo do nosso lado = 1
    tab_1(Tabi, L1),            % Verifica se a jogada X é válida
    maximo(L1, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U), % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),!.


jogada_2(Ei, _, Ei) :-
    terminal(Ei),!.
%jogada_2 que verifica a regra suplementar 1 se aplica
jogada_2([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :-
    tab_1(Tabi, L1),
    maximo(L1, 0),          % O adversario nao tem como jogar (Regra supl 1)
    tab_2(Tabi, L2),        % Verifica se a jogada X é válida
    maximo(L2, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),  % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),
    tab_1(Tabn, L1n),
    \+ maximo(L1n, 0),!.        % A jogada introduz novas pecas no lado do adv
jogada_2([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :- % Repete-se o mesmo que na anterior mas para o caso de o valor maximo do nosso lado = 1
    tab_1(Tabi, L1),
    maximo(L1, 0),              % O adversario nao tem como jogar (Regra supl 1)
    tab_2(Tabi, L2),            % Verifica se a jogada X é válida
    maximo(L2, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U), % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),
    tab_1(Tabn, L1n),
    \+ maximo(L1n, 0),!.
%jogada_2 que verifica a regra suplementar 1 se aplica
jogada_2([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :-
    tab_2(Tabi, L2),        % Verifica se a jogada X é válida
    maximo(L2, M),
    M @> 1,
    nth1(X, Tabi, Val),
    Val @> 1,!,
    distribui([P1,P2,Tabi], X, En, U),  % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),!.
jogada_2([P1,P2,Tabi], X, [P1n, P2n, Tabn]) :- % Repete-se o mesmo que na anterior mas para o caso de o valor maximo do nosso lado = 1
    tab_2(Tabi, L2),            % Verifica se a jogada X é válida
    maximo(L2, 1),
    nth1(X, Tabi, 1),!,
    distribui([P1,P2,Tabi], X, En, U), % Executa jogada X
    captura(En, X, U, [P1n, P2n, Tabn]),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                 OPERACOES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% X = 1
op([P1, P2, Tab], p1, 1, En) :-
    jogada_1([P1, P2, Tab], 1, En).
% X = 2
op([P1, P2, Tab], p1, 2, En) :-
    jogada_1([P1, P2, Tab], 2, En).
% X = 3
op([P1, P2, Tab], p1, 3, En) :-
    jogada_1([P1, P2, Tab], 3, En).
% X = 4
op([P1, P2, Tab], p1, 4, En) :-
    jogada_1([P1, P2, Tab], 4, En).
% X = 5
op([P1, P2, Tab], p1, 5, En) :-
    jogada_1([P1, P2, Tab], 5, En).
% X = 6
op([P1, P2, Tab], p1, 6, En) :-
    jogada_1([P1, P2, Tab], 6, En).
% X = 7
op([P1, P2, Tab], p2, 7, En) :-
    jogada_2([P1, P2, Tab], 7, En).
% X = 8
op([P1, P2, Tab], p2, 8, En) :-
    jogada_2([P1, P2, Tab], 8, En).
% X = 9
op([P1, P2, Tab], p2, 9, En) :-
    jogada_2([P1, P2, Tab], 9, En).
% X = 10
op([P1, P2, Tab], p2, 10, En) :-
    jogada_2([P1, P2, Tab], 10, En).
% X = 11
op([P1, P2, Tab], p2, 11, En) :-
    jogada_2([P1, P2, Tab], 11, En).
% X = 12
op([P1, P2, Tab], p2, 12, En) :-
    jogada_2([P1, P2, Tab], 12, En).

op([P1, P2, [0,0,0,0,0,0|T]], p1, 0, [P1, P2, [0,0,0,0,0,0|T]]).
op([P1, P2, [_,_,_,_,_,_,0,0,0,0,0,0]], p2, 0, [P1, P2, [_,_,_,_,_,_,0,0,0,0,0,0]]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


oper(Ei, J, X, En) :-
    op(Ei, J, X, En).