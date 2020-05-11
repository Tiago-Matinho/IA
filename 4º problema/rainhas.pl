% cada posicao pode ter "r" (rainha) ou "v" (vazio)
:- dynamic(estado_inicial/1).
:- dynamic(tamanho/1).
:- dynamic(pos_y/1).
:- dynamic(pos_x/1).
:- dynamic(pos_xy/2).
:- dynamic(n_pos/1).


tamanho(8).
estado_inicial([[v,r,v,v],[v,v,v,v],[v,v,v,v],[v,v,v,v]]).

% conta quantos X existe em lista
conta_rainhas([], C, C).
conta_rainhas([r|T], C, Cf) :-
    C1 is C + 1,
    conta_rainhas(T, C1, Cf).
conta_rainhas([v|T], C, Cf) :-
    conta_rainhas(T, C, Cf).

% uma rainha ou menos 
menos_que_uma(L) :-
    conta_rainhas(L, 0, C),
    C @< 2.

zero_rainhas(L) :-
    conta_rainhas(L, 0, 0).


% verifica se existe uma ou menos rainhas nas sublistas da lista
lista([]).
lista([H|T]) :-
    menos_que_uma(H),
    lista(T).

% passa as colunas para sublistas
lista_colunas_aux([], [], _).
lista_colunas_aux([H1|T1], [H2|T2], C) :-
    nth0(C, H1, H2),
    lista_colunas_aux(T1, T2, C).

lista_colunas(_, [], N) :- tamanho(N).
lista_colunas(Tab, [H|T], C) :-
    C1 is C + 1,
    lista_colunas_aux(Tab, H, C),
    lista_colunas(Tab, T, C1).

% busca o valor do tabuleiro na posicao X Y
get(Tab, X, Y, V) :-
    X1 is X - 1, Y1 is Y - 1,
    nth0(Y1, Tab, Tabb),
    nth0(X1, Tabb, V).

% verifica se X e Y pertencem ao tabuleiro
dentro_tab(X, Y) :-
    tamanho(N),
    X @>0, X @=<N,
    Y @>0, Y @=<N.

%diagonais
diagonal_dir_baixo(_, X, Y, []) :-
    \+dentro_tab(X, Y).
diagonal_dir_baixo(Tab, X, Y, [H|T]) :-
    get(Tab, X, Y, H),
    X1 is X + 1,
    Y1 is Y + 1,
    diagonal_dir_baixo(Tab, X1, Y1, T).

diagonal_esq_baixo(_, X, Y, []) :-
    \+dentro_tab(X, Y).
diagonal_esq_baixo(Tab, X, Y, [H|T]) :-
    get(Tab, X, Y, H),
    X1 is X - 1,
    Y1 is Y + 1,
    diagonal_esq_baixo(Tab, X1, Y1, T).

% altera o y
diagonais_y(_, X, Y, []) :-
    \+dentro_tab(X, Y).
diagonais_y(Tab, X, Y, [H1,H2|T]) :-
    dentro_tab(X, Y),
    diagonal_dir_baixo(Tab, X, Y, H1),
    diagonal_esq_baixo(Tab, X, Y, H2),
    Y1 is Y + 1,
    diagonais_y(Tab, X, Y1, T).

%altera o x
diagonais_x(_, X, Y, []) :-
    \+dentro_tab(X, Y).
diagonais_x(Tab, X, Y, [H1,H2|T]) :-
    dentro_tab(X, Y),
    diagonal_dir_baixo(Tab, X, Y, H1),
    diagonal_esq_baixo(Tab, X, Y, H2),
    X1 is X + 1,
    diagonais_x(Tab, X1, Y, T).

%retorna todas as diagonais
diagonais(Tab, Lf) :-
    tamanho(N),
    diagonais_y(Tab, 1, 1, D1),
    diagonais_x(Tab, 2, 1, D2),
    diagonais_y(Tab, N, 2, D3),
    append(D1,D2,D12),
    append(D12,D3,L),
    corta(L, Lf),!.

corta([], []).
corta([H|T1], [H|T2]) :-
    \+member(H, T1),
    length(H, C),
    C @> 1,
    corta(T1, T2).
corta([_|T], L) :-
    corta(T, L).


% existem N rainhas
n_rainhas_aux([], C, C).
n_rainhas_aux([H|T], C, Cf) :-
    conta_rainhas(H, 0, Cn),
    Cnn is C + Cn,
    n_rainhas_aux(T, Cnn, Cf).

n_rainhas(Tab) :-
    tamanho(N),
    n_rainhas_aux(Tab, 0, N).

terminal(G) :-
    n_rainhas(G),
    lista(G),                               %linhas
    lista_colunas(G, Col, 0), lista(Col),   %colunas
    diagonais(G, D), lista(D).              %diagonais


nova_rainha_aux([v|T], 1, [r|T]).
nova_rainha_aux([H|T1], X, [H|T2]) :-
    X1 is X - 1,
    nova_rainha_aux(T1, X1, T2).

nova_rainha([H|T], X, 1, [N|T]) :-
    nova_rainha_aux(H, X, N).
nova_rainha([H|T1], X, Y, [H|T2]) :-
    Y1 is Y - 1,
    nova_rainha(T1, X, Y1, T2).

% verifica em que linhas se pode inserir uma rainha
pos_val_y_aux(Tab, Y) :-
    Y1 is Y - 1,
    nth0(Y1, Tab, L),
    zero_rainhas(L).

pos_val_y(_, N1) :- tamanho(N), N1 is N + 1.
pos_val_y(Tab, Y) :-
    tamanho(N), Y @=< N,
    pos_val_y_aux(Tab, Y),
    asserta(pos_y(Y)),
    Y1 is Y + 1,
    pos_val_y(Tab, Y1).
pos_val_y(Tab, Y) :-
    tamanho(N), Y @=< N,
    Y1 is Y + 1,
    pos_val_y(Tab, Y1).

% verifica em que colunas se pode inserir uma rainha
pos_val_x_aux(Tab, X) :-
    X1 is X - 1,
    lista_colunas_aux(Tab, L, X1),
    zero_rainhas(L).

pos_val_x(_, N1) :- tamanho(N), N1 is N + 1.
pos_val_x(Tab, X) :-
    tamanho(N), X @=< N,
    pos_val_x_aux(Tab, X),
    asserta(pos_x(X)),
    X1 is X + 1,
    pos_val_x(Tab, X1).
pos_val_x(Tab, X) :-
    tamanho(N), X @=< N,
    X1 is X + 1,
    pos_val_x(Tab, X1).


% atualiza as novas posicoes validas
pos_val(Tab) :-
    retractall(pos_y(_)),
    retractall(pos_x(_)),
    retractall(n_pos(_)),
    pos_val_y(Tab, 1),
    pos_val_x(Tab, 1),
    findall(pos_xy(X, Y), (pos_y(Y), pos_x(X)),Lop),
    length(Lop, N),
    asserta(n_pos(N)),
    escreve(Lop).

escreve([]).
escreve([H|T]) :-
    asserta(H),
    escreve(T).


op(E, joga(X, Y), En, C) :-
    pos_val(E),
    oper(E, X, Y, En, C).

oper(Tab, X, Y, Ntab, 1) :-
    pos_xy(X,Y),
    retract(pos_xy(X,Y)),
    nova_rainha(Tab, X, Y, Ntab),
    diagonais(Ntab, D), lista(D).
    
%heuristica
heur(Tab, H) :-
    pos_val(Tab),
    n_pos(H).