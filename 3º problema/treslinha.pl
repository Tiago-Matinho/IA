
%a)
% cada posicao pode ter "x", "o" ou "v" (vazio)
%estado_inicial([[v,v,v,v],[o,x,v,v],[x,o,x,v],[x,x,o,o],[v,v,v,v]]).
:- dynamic(estado_inicial/1).
%estado_inicial([[v,v,v,x],[v,v,o,x],[v,o,x,o],[v,o,x,x],[v,x,o,o]]).
estado_inicial([[x,v,v,v],[v,x,v,v],[v,v,x,v],[v,v,v,v],[v,v,v,v]]).

%b)
terminal(G) :- linhas(G,_).
terminal(G) :- colunas(G,_).
terminal(G) :- diagonal(G,_).
terminal(G) :- cheio(G).

tres_vertical([X,X,X,_,_],X).
tres_vertical([_,X,X,X,_],X).
tres_vertical([_,_,X,X,X],X).

linhas([L,_,_,_,_],X) :- X \= v, tres_vertical(L,X).
linhas([_,L,_,_,_],X) :- X \= v, tres_vertical(L,X).
linhas([_,_,L,_,_],X) :- X \= v, tres_vertical(L,X).
linhas([_,_,_,L,_],X) :- X \= v, tres_vertical(L,X).
linhas([_,_,_,_,L],X) :- X \= v, tres_vertical(L,X).

tres_horizontal([X|_],[X|_], [X|_] ,X).
tres_horizontal([_,X|_],[_,X|_], [_,X|_] ,X).
tres_horizontal([_,_,X|_],[_,_,X|_], [_,_,X|_] ,X).
tres_horizontal([_,_,_,X],[_,_,_,X], [_,_,_,X] ,X).

colunas([L1,L2,L3,_],X) :- X \= v, tres_horizontal(L1,L2,L3,X).
colunas([_,L2,L3,L4],X) :- X \= v, tres_horizontal(L2,L3,L4,X).

tres_diagonal_esq([X,_,_,_],[_,X,_,_],[_,_,X,_], X).
tres_diagonal_esq([_,X,_,_],[_,_,X,_],[_,_,_,X], X).

tres_diagonal_dir([_,_,_,X],[_,_,X,_],[_,X,_,_], X).
tres_diagonal_dir([_,_,X,_],[_,X,_,_],[X,_,_,_], X).

diagonal([L1,L2,L3,_,_],X) :- X \= v, tres_diagonal_esq(L1,L2,L3,X). %vermelho e laranja
diagonal([_,L2,L3,L4,_],X) :- X \= v, tres_diagonal_esq(L2,L3,L4,X). %vermelho e laranja
diagonal([_,_,L3,L4,L5],X) :- X \= v, tres_diagonal_esq(L3,L4,L5,X). %vermelho e laranja

diagonal([_,_,L3,L2,L1],X) :- X \= v, tres_diagonal_dir(L1,L2,L3,X). %vermelho e laranja
diagonal([_,L4,L3,L2,_],X) :- X \= v, tres_diagonal_dir(L2,L3,L4,X). %vermelho e laranja
diagonal([L5,L4,L3,_,_],X) :- X \= v, tres_diagonal_dir(L3,L4,L5,X). %vermelho e laranja


cheio([L1,L2,L3,L4,L5]) :- 
	append(L1,L2, L12),
	append(L12, L3, L123),
	append(L123, L4, L1234),
	append(L1234, L5, L12345),
	\+ member(v, L12345).

%c)
%função de utilidade, retorna o valor dos estados terminais, 1 ganha -1 perde
valor(G, 10) :- linhas(G,x).
valor(G, 10) :- colunas(G,x).
valor(G, 10) :- diagonal(G,x).
valor(G, -10) :- linhas(G,o).
valor(G, -10) :- colunas(G,o).
valor(G, -10) :- diagonal(G,o).
valor(_, 0).

%d)

cair_aux([v,C,B,A], 1) :- A \= v, B \= v, C \= v.
cair_aux([v,v,B,A], 2) :- A \= v, B \= v.
cair_aux([v,v,v,A], 3) :- A \= v.
cair_aux([v,v,v,v], 4).

cair([C1,_,_,_,_], 1, Y) :- cair_aux(C1, Y).
cair([_,C2,_,_,_], 2, Y) :- cair_aux(C2, Y).
cair([_,_,C3,_,_], 3, Y) :- cair_aux(C3, Y).
cair([_,_,_,C4,_], 4, Y) :- cair_aux(C4, Y).
cair([_,_,_,_,C5], 5, Y) :- cair_aux(C5, Y).

joga_linha([v,C2,C3,C4], 1, J, [J,C2,C3,C4]).
joga_linha([C1,v,C3,C4], 2, J, [C1,J,C3,C4]).
joga_linha([C1,C2,v,C4], 3, J, [C1,C2,J,C4]).
joga_linha([C1,C2,C3,v], 4, J, [C1,C2,C3,J]).

% X = 1
joga_pos([L1,L2,L3,L4,L5], 1, Y, J, [NL,L2,L3,L4,L5]) :- joga_linha(L1, Y, J, NL).
% X = 2
joga_pos([L1,L2,L3,L4,L5], 2, Y, J, [L1,NL,L3,L4,L5]) :- joga_linha(L2, Y, J, NL).
% X = 3
joga_pos([L1,L2,L3,L4,L5], 3, Y, J, [L1,L2,NL,L4,L5]) :- joga_linha(L3, Y, J, NL).
% X = 4
joga_pos([L1,L2,L3,L4,L5], 4, Y, J, [L1,L2,L3,NL,L5]) :- joga_linha(L4, Y, J, NL).
% X = 5
joga_pos([L1,L2,L3,L4,L5], 5, Y, J, [L1,L2,L3,L4,NL]) :- joga_linha(L5, Y, J, NL).

% oper(estado,jogador,jogada,estado seguinte)
oper(E, J,joga(X,Y), En) :-
	joga_vazio(E,J,X, Y, En).

joga_vazio([L1,L2,L3,L4,L5], J, 1, Y, En) :- cair([L1,L2,L3,L4,L5],1,Y), joga_pos([L1,L2,L3,L4,L5],1,Y,J,En).
joga_vazio([L1,L2,L3,L4,L5], J, 2, Y, En) :- cair([L1,L2,L3,L4,L5],2,Y), joga_pos([L1,L2,L3,L4,L5],2,Y,J,En).
joga_vazio([L1,L2,L3,L4,L5], J, 3, Y, En) :- cair([L1,L2,L3,L4,L5],3,Y), joga_pos([L1,L2,L3,L4,L5],3,Y,J,En).
joga_vazio([L1,L2,L3,L4,L5], J, 4, Y, En) :- cair([L1,L2,L3,L4,L5],4,Y), joga_pos([L1,L2,L3,L4,L5],4,Y,J,En).
joga_vazio([L1,L2,L3,L4,L5], J, 5, Y, En) :- cair([L1,L2,L3,L4,L5],5,Y), joga_pos([L1,L2,L3,L4,L5],5,Y,J,En).

imprime_tabuleiro([[C11,C12,C13,C14],[C21,C22,C23,C24],[C31,C32,C33,C34],[C41,C42,C43,C44],[C51,C52,C53,C54]]) :-
	write(C11), write('|'), write(C21), write('|'), write(C31), write('|'), write(C41), write('|'), write(C51), nl,
	write(C12), write('|'), write(C22), write('|'), write(C32), write('|'), write(C42), write('|'), write(C52), nl,
	write(C13), write('|'), write(C23), write('|'), write(C33), write('|'), write(C43), write('|'), write(C53), nl,
	write(C14), write('|'), write(C24), write('|'), write(C34), write('|'), write(C44), write('|'), write(C54), nl.

joga_jogador(X) :-
	retract(estado_inicial(Ei)),
	cair(Ei, X, Y),
	joga_vazio(Ei, o, X, Y, En),
	asserta(estado_inicial(En)),
	imprime_tabuleiro(En).

joga_bot() :-
	joga(joga(X,Y)),
	retract(estado_inicial(Ei)),
	joga_vazio(Ei, x, X, Y, En),
	asserta(estado_inicial(En)),
	imprime_tabuleiro(En).
