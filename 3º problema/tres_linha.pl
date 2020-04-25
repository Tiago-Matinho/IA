% cada posicao pode ter "x", "o" ou "v" (vazio)
%estado_inicial([[x,v,v],[o,o,v],[v,v,x]]).

%a)
%estado_inicial([[v,v,v,v,v],[v,v,v,v,v],[v,v,v,v,v],[v,v,v,v,v]]).
estado_inicial([[v,v,v,v,v],[v,v,v,o,v],[o,o,x,o,v],[o,x,o,x,x]]).

%b)
terminal(G) :- linhas(G,_).
terminal(G) :- colunas(G,_).
terminal(G) :- diagonal(G,_).
terminal(G) :- cheio(G).

tres_horizontal([X,X,X,_,_],X).
tres_horizontal([_,X,X,X,_],X).
tres_horizontal([_,_,X,X,X],X).

linhas([L,_,_,_],X) :- X \= v, tres_horizontal(L,X).
linhas([_,L,_,_],X) :- X \= v, tres_horizontal(L,X).
linhas([_,_,L,_],X) :- X \= v, tres_horizontal(L,X).
linhas([_,_,_,L],X) :- X \= v, tres_horizontal(L,X).

tres_vertical([X|_],[X|_], [X|_] ,X).
tres_vertical([_,X|_],[_,X|_], [_,X|_] ,X).
tres_vertical([_,_,X|_],[_,_,X|_], [_,_,X|_] ,X).
tres_vertical([_,_,_,X|_],[_,_,_,X|_], [_,_,_,X|_] ,X).
tres_vertical([_,_,_,_,X],[_,_,_,_,X], [_,_,_,_,X] ,X).

colunas([L1,L2,L3,_],X) :- X \= v, tres_vertical(L1,L2,L3,X).
colunas([_,L1,L2,L3],X) :- X \= v, tres_vertical(L1,L2,L3,X).

tres_diagonal_esq([X,_,_,_,_],[_,X,_,_,_],[_,_,X,_,_], X).
tres_diagonal_esq([_,X,_,_,_],[_,_,X,_,_],[_,_,_,X,_], X).
tres_diagonal_esq([_,_,X,_,_],[_,_,_,X,_],[_,_,_,_,X], X).

tres_diagonal_dir([_,_,_,_,X],[_,_,_,X,_],[_,_,X,_,_], X).
tres_diagonal_dir([_,_,_,X,_],[_,_,X,_,_],[_,X,_,_,_], X).
tres_diagonal_dir([_,_,X,_,_],[_,X,_,_,_],[X,_,_,_,_], X).

diagonal([L1,L2,L3,_],X) :- X \= v, tres_diagonal_esq(L1,L2,L3,X). %amarelo
diagonal([_,L1,L2,L3],X) :- X \= v, tres_diagonal_esq(L1,L2,L3,X). %vermelho

diagonal([L1,L2,L3,_],X) :- X \= v, tres_diagonal_dir(L1,L2,L3,X). %roxo
diagonal([_,L1,L2,L3],X) :- X \= v, tres_diagonal_dir(L1,L2,L3,X). %azul

cheio([L1,L2,L3,L4]) :- 
	append(L1,L2, L12),
	append(L12, L3, L123),
	append(L123, L4, L1234),
	\+ member(v, L1234).

%c)
%função de utilidade, retorna o valor dos estados terminais, 1 ganha -1 perde
valor(G, 1) :- linhas(G,x).
valor(G, 1) :- colunas(G,x).
valor(G, 1) :- diagonal(G,x).
valor(G, -1) :- linhas(G,o).
valor(G, -1) :- colunas(G,o).
valor(G, -1) :- diagonal(G,o).
valor(_, 0).

%d)

%sucede se na lista de baixo (que representa a parte inferior da tabela) na coluna C
%estiver vazia. Logo se fosse jogada uma peca nesta coluna iria parar na linha 4

cair1([_,_,_,L4], C, 4) :- C1 is C-1, nth0(C1,L4,v).	%verifica se a pos (C, 4) está vazia
cair2([_,_,L3,_], C, 3) :- C1 is C-1, nth0(C1,L3,v).	
cair3([_,L2,_,_], C, 2) :- C1 is C-1, nth0(C1,L2,v).
cair4([L1,_,_,_], C, 1) :- C1 is C-1, nth0(C1,L1,v).

cair([L1,L2,L3,L4], C, Y) :-
	cair1([L1,L2,L3,L4],C, Y).
%daqui para a frente apenas sucedem se as linhas de baixo NAO estiverem VAZIAS
cair([L1,L2,L3,L4], C, Y) :-
	\+cair1([L1,L2,L3,L4],C, _),	%caso a linha 4 nao esteja vazia e se a linha 3 estiver vazia
	cair2([L1,L2,L3,L4],C, Y).
cair([L1,L2,L3,L4], C, Y) :-
	\+cair1([L1,L2,L3,L4],C, _),
	\+cair2([L1,L2,L3,L4],C, _),
	cair3([L1,L2,L3,L4],C, Y).
cair([L1,L2,L3,L4], C, Y) :-
	\+cair1([L1,L2,L3,L4],C, _),
	\+cair2([L1,L2,L3,L4],C, _),
	\+cair3([L1,L2,L3,L4],C, _),
	cair4([L1,L2,L3,L4],C, Y).


joga_col1([v,C2,C3,C4,C5], [J,C2,C3,C4,C5], J).
joga_col2([C1,v,C3,C4,C5], [C1,J,C3,C4,C5], J).
joga_col3([C1,C2,v,C4,C5], [C1,C2,J,C4,C5], J).
joga_col4([C1,C2,C3,v,C5], [C1,C2,C3,J,C5], J).
joga_col5([C1,C2,C3,C4,v], [C1,C2,C3,C4,J], J).

% Y = 1
joga_pos([L1,L2,L3,L4], 1, 1, J, [NL,L2,L3,L4]) :- joga_col1(L1,NL,J).
joga_pos([L1,L2,L3,L4], 2, 1, J, [NL,L2,L3,L4]) :- joga_col2(L1,NL,J).
joga_pos([L1,L2,L3,L4], 3, 1, J, [NL,L2,L3,L4]) :- joga_col3(L1,NL,J).
joga_pos([L1,L2,L3,L4], 4, 1, J, [NL,L2,L3,L4]) :- joga_col4(L1,NL,J).
joga_pos([L1,L2,L3,L4], 5, 1, J, [NL,L2,L3,L4]) :- joga_col5(L1,NL,J).
% Y = 2
joga_pos([L1,L2,L3,L4], 1, 2, J, [L1,NL,L3,L4]) :- joga_col1(L2,NL,J).
joga_pos([L1,L2,L3,L4], 2, 2, J, [L1,NL,L3,L4]) :- joga_col2(L2,NL,J).
joga_pos([L1,L2,L3,L4], 3, 2, J, [L1,NL,L3,L4]) :- joga_col3(L2,NL,J).
joga_pos([L1,L2,L3,L4], 4, 2, J, [L1,NL,L3,L4]) :- joga_col4(L2,NL,J).
joga_pos([L1,L2,L3,L4], 5, 2, J, [L1,NL,L3,L4]) :- joga_col5(L2,NL,J).
% Y = 3
joga_pos([L1,L2,L3,L4], 1, 3, J, [L1,L2,NL,L4]) :- joga_col1(L3,NL,J).
joga_pos([L1,L2,L3,L4], 2, 3, J, [L1,L2,NL,L4]) :- joga_col2(L3,NL,J).
joga_pos([L1,L2,L3,L4], 3, 3, J, [L1,L2,NL,L4]) :- joga_col3(L3,NL,J).
joga_pos([L1,L2,L3,L4], 4, 3, J, [L1,L2,NL,L4]) :- joga_col4(L3,NL,J).
joga_pos([L1,L2,L3,L4], 5, 3, J, [L1,L2,NL,L4]) :- joga_col5(L3,NL,J).
% Y = 4
joga_pos([L1,L2,L3,L4], 1, 4, J, [L1,L2,L3,NL]) :- joga_col1(L4,NL,J).
joga_pos([L1,L2,L3,L4], 2, 4, J, [L1,L2,L3,NL]) :- joga_col2(L4,NL,J).
joga_pos([L1,L2,L3,L4], 3, 4, J, [L1,L2,L3,NL]) :- joga_col3(L4,NL,J).
joga_pos([L1,L2,L3,L4], 4, 4, J, [L1,L2,L3,NL]) :- joga_col4(L4,NL,J).
joga_pos([L1,L2,L3,L4], 5, 4, J, [L1,L2,L3,NL]) :- joga_col5(L4,NL,J).

% oper(estado,jogador,jogada,estado seguinte)
oper(E, J,joga(X,Y), En) :-
	joga_vazio(E,J,X, Y, En).

joga_vazio([L1,L2,L3,L4], J, 1, Y, En) :- cair([L1,L2,L3,L4],1,Y), joga_pos([L1,L2,L3,L4],1,Y,J,En).
joga_vazio([L1,L2,L3,L4], J, 2, Y, En) :- cair([L1,L2,L3,L4],2,Y), joga_pos([L1,L2,L3,L4],2,Y,J,En).
joga_vazio([L1,L2,L3,L4], J, 3, Y, En) :- cair([L1,L2,L3,L4],3,Y), joga_pos([L1,L2,L3,L4],3,Y,J,En).
joga_vazio([L1,L2,L3,L4], J, 4, Y, En) :- cair([L1,L2,L3,L4],4,Y), joga_pos([L1,L2,L3,L4],4,Y,J,En).
joga_vazio([L1,L2,L3,L4], J, 5, Y, En) :- cair([L1,L2,L3,L4],5,Y), joga_pos([L1,L2,L3,L4],5,Y,J,En).
