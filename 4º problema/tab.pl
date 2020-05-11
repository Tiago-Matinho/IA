
% fazer tabuleiro
faz_linha([],0).
faz_linha([v|T], N) :-
    N1 is N - 1,
    faz_linha(T, N1).

faz_tab_aux([], 0, _).
faz_tab_aux([H|T], Ncur, N) :-
    N1 is Ncur - 1,
    faz_linha(H, N),
    faz_tab_aux(T, N1, N).

faz_tab(N) :-
    faz_tab_aux(T, N, N),
    asserta(estado_inicial(T)),
    asserta(tamanho(N)).
