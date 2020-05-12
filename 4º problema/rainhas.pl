:- dynamic(tamanho/1).
:- dynamic(coor_diagonais/1).
:- dynamic(pos_possiveis/2).
:- dynamic(estado_inicial/1).


rainhas_na_linha([], C, C).
rainhas_na_linha([H|T], C, Cf) :-
	member(H, T),
	C1 is C + 1,
	rainhas_na_linha(T, C1, Cf).
rainhas_na_linha([H|T], C, Cf) :-
	\+member(H, T),
	rainhas_na_linha(T, C, Cf).

diagonal_dir([], _, _, C, C).
diagonal_dir([H|T], Y, Diff, C, Cf) :-
	Yn is Y - Diff,
	Yn \= H,
	DiffN is Diff + 1,
	diagonal_dir(T, Y, DiffN, C, Cf).
diagonal_dir([H|T], Y, Diff, C, Cf) :-
	Yn is Y - Diff,
	Yn = H,
	asserta(remover(Diff, Y)),
	C1 is C + 1,
	DiffN is Diff + 1,
	diagonal_dir(T, Y, DiffN, C1, Cf).


diagonais_dir([], C, C).
diagonais_dir([H|T], C, Cf) :-
	diagonal_dir(T, H, 1, 0, Cn),
	Cnn is C + Cn,
	diagonais_dir(T, Cnn, Cf).
diagonais_dir([H|T], C, Cf) :-
	diagonal_dir(T, H, 1, 0, Cn),
	Cnn is C + Cn,
	diagonais_dir(T, Cnn, Cf).

dentro(X, Y, N) :-
	X @> 0, X @=< N,
	Y @> 0, Y @=< N.

diagonal_cima_aux(X, Y, [(X,Y)|T], N) :-
	dentro(X,Y,N),
	X1 is X + 1, Y1 is Y - 1,
	diagonal_cima_aux(X1, Y1, T, N).
diagonal_cima_aux(X, Y, [], N) :-
	\+dentro(X, Y, N).

diagonal_baixo_aux(X, Y, [(X,Y)|T], N) :-
	dentro(X,Y,N),
	X1 is X + 1, Y1 is Y + 1,
	diagonal_baixo_aux(X1, Y1, T, N).
diagonal_baixo_aux(X, Y, [], N) :-
	\+dentro(X, Y, N).

diagonal_y(Y, [D1,D2|T]) :-
	tamanho(N),
	dentro(1, Y, N),
	diagonal_cima_aux(1, Y, D1, N),
	diagonal_baixo_aux(1, Y, D2, N),
	Y1 is Y + 1,
	diagonal_y(Y1, T).
diagonal_y(Y, []) :-
	tamanho(N),
	\+dentro(1, Y, N).

diagonal_cima_x(X, [D|T]) :-
	tamanho(N),
	dentro(X, N, N),
	diagonal_cima_aux(X, N, D, N),
	X1 is X + 1,
	diagonal_cima_x(X1, T).
diagonal_cima_x(X, []) :-
	tamanho(N),
	\+dentro(X, N, N).

diagonal_baixo_x(X, [D|T]) :-
	tamanho(N),
	dentro(X, 1, N),
	diagonal_baixo_aux(X, 1, D, N),
	X1 is X + 1,
	diagonal_baixo_x(X1, T).
diagonal_baixo_x(X, []) :-
	tamanho(N),
	\+dentro(X, 1, N).

diagonais :-
	diagonal_y(1, D1),
	diagonal_baixo_x(2, D2),
	diagonal_cima_x(2, D3),
	append(D1,D2,D12),
	append(D12,D3,D123),
	corta(D123, L),
	asserta(coor_diagonais(L)).
	
corta([], []).
corta([H|T1], [H|T2]) :-
    \+member(H, T1),
    length(H, C),
    C @> 1,
    corta(T1, T2).
corta([_|T], L) :-
	corta(T, L),!.

%primeiro o tab depois a diagonal que se está a seguir
rainhas_na_diagonal(_, [], C, C).
rainhas_na_diagonal(E, [(X, Y)|T], C, Cf) :-
	X1 is X - 1,
	nth0(X1, E, Y),
	C1 is C + 1,
	rainhas_na_diagonal(E, T, C1, Cf).
rainhas_na_diagonal(E, [_|T], C, Cf) :-
	rainhas_na_diagonal(E, T, C, Cf).

rainhas_nas_diagonais(_, [], C, C). 
rainhas_nas_diagonais(E, [H|T], C, Cf) :-
	rainhas_na_diagonal(E, H, 0, Cn),
	ajuste(Cn, Cnn),
	Cnnn is C + Cnn,
	rainhas_nas_diagonais(E, T, Cnnn, Cf).

ajuste(C, Cn) :- C @> 0, Cn is C - 1.
ajuste(C, C).

diagonais_conta(E, C) :-
	coor_diagonais(L),
	rainhas_nas_diagonais(E, L, 0, C), !.

heur(E, H) :-
	rainhas_na_linha(E, 0, C1),
	diagonais_conta(E, C2),
	H is C1 + C2.

terminal(E) :- heur(E, 0).

faz_possiveis(E) :-
	retractall(pos_possiveis(_, _)),
	tamanho(N),
	findall((X,Y), (between(1,N,X), between(1,N, Y)), L),
	escreve(E, L).

escreve(_, []).
escreve(E, [(X,Y)|T]) :-
	rainha_na_pos(E, X, Y),
	escreve(E, T).
escreve(E, [(X,Y)|T]) :-
	\+rainha_na_pos(E, X, Y),
	asserta(pos_possiveis(X,Y)),
	escreve(E, T).

rainha_na_pos(E, X, Y) :-
	X1 is X - 1,
	nth0(X1, E, Y).

op(E, rainha(X, Y), En, 1) :-
	faz_possiveis(E),
    pos_possiveis(X, Y),
    muda_pos(E, X, Y, En).

muda_pos([_|T], 1, Y, [Y|T]).
muda_pos([H|T1], X, Y, [H|T2]) :-
    X1 is X - 1,
    muda_pos(T1, X1, Y, T2).

lista_de_n(0, []).
lista_de_n(N, [H|T]) :-
	N1 is N - 1,
	tamanho(S),
	random(1, S, H),
	lista_de_n(N1, T).

faz_tab(N) :-
	retractall(tamanho(_)),
	retractall(coor_diagonais(_)),
	retractall(pos_possiveis(_, _)),
	retractall(estado_inicial(_)),
	asserta(tamanho(N)),
	lista_de_n(N, L),
	asserta(estado_inicial(L)),
	diagonais,
	imprime_tab(L), write('Solução: '), nl,!.


imprime_pos([], _) :-
	nl.
imprime_pos([Y|T], Y) :-
	write('r '),
	imprime_pos(T, Y).
imprime_pos([A|T], Y) :-
	A \= Y,
	write('v '),
	imprime_pos(T, Y).

imprime_linha(_, N1) :- tamanho(N), N1 is N + 1.
imprime_linha(E, Y) :-
	imprime_pos(E, Y),
	Y1 is Y + 1,
	imprime_linha(E, Y1).

imprime_tab(E) :-
	imprime_linha(E, 1), !.
