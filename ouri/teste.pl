%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:-dynamic(estado_atual/1).
:-dynamic(escolha/1).


%recebe os tabuleiros e os pontos q ganhou. Os tabuleiros atuais são passados
%com o estado atual, a jogada com a jogada possivel
recebe_jogada(Tabn, P) :-
    estado_atual((Pe, Pd, Tab)),
    atomics_to_string(Tab, ",", Tabstr),
    escolha(Es),
    process_create(path('python3.8'), ['joga.py', Pe, Pd, Tabstr, Es], [stdout(pipe(In))]),
    read_string(In, _, X),
    split_string(X, "\n", "", L1),
    nth1(1, L1, L2),
    split_string(L2, ",", "", L3),
    faz_lista(L3, Tabn),
    nth1(2, L1, L4),
    atom_number(L4, P).

% transforma lista de str para lista de int
faz_lista([], []).
faz_lista([H1|T1], [H2|T2]) :-
	atom_number(H1, H2),
	faz_lista(T1, T2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


terminal((X, _, _)) :-
    X @> 24.
terminal((_, X, _)) :-
    X @> 24.


valor((X, _, _), 100) :- X @> 24, jogador(e).
valor((_, X, _), 100) :- X @> 24, jogador(d).
valor((_, X, _), -100) :- X @> 24, jogador(e).
valor((X, _, _), -100) :- X @> 24, jogador(d).
valor((_, _, _), 0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lista_lado_e([A, B, C, D, E, F |_], [A, B, C, D, E, F]).
lista_lado_d([_, _, _, _, _, _ |T], T).

maximo_lista([], -1).
maximo_lista([H|T], M) :-
    maximo_lista(T, A),
    M is max(H, A).

jogada_valida(L, X) :-
    maximo_lista(L, Max),
    Max = 1,
    nth1(X, L, Val),
    Val = 1.
jogada_valida(L, X) :-
    nth1(X, L, Val),
    Val @> 1.

%faz a jogada na posicao X, retorna o tabuleiro e os pontos
faz_jogada(Ei, X, Tabn, P) :-
    retractall(estado_atual(_)),        %limpa estados anteriores
    retractall(escolha(_)),             %limpa escolhas anteriores
    asserta(estado_atual(Ei)),          %escreve o estado atual
    asserta(escolha(X)),                %escreve a escolha para o python
    recebe_jogada(Tabn, P).             %recebe para Tabn o tabuleiro do python
                                        %o mesmo para os pontos no P

%//TODO funcao para reintroduzir pecas no outro lado

% X = 1
joga_pos((Pe, Pd, Tab), e, 1, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 1),!,
    faz_jogada((Pe, Pd, Tab), 1, Tabn, P),
    Pen is Pe + P.
% X = 2
joga_pos((Pe, Pd, Tab), e, 2, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 2),!,
    faz_jogada((Pe, Pd, Tab), 2, Tabn, P),
    Pen is Pe + P.
% X = 3
joga_pos((Pe, Pd, Tab), e, 3, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 3),!,
    faz_jogada((Pe, Pd, Tab), 3, Tabn, P),
    Pen is Pe + P.
% X = 4
joga_pos((Pe, Pd, Tab), e, 4, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 4),!,
    faz_jogada((Pe, Pd, Tab), 4, Tabn, P),
    Pen is Pe + P.
% X = 5
joga_pos((Pe, Pd, Tab), e, 5, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 5),!,
    faz_jogada((Pe, Pd, Tab), 5, Tabn, P),
    Pen is Pe + P.
% X = 6
joga_pos((Pe, Pd, Tab), e, 6, (Pen, Pd, Tabn)) :-
    lista_lado_e(Tab, Tab_e),
    jogada_valida(Tab_e, 6),!,
    faz_jogada((Pe, Pd, Tab), 6, Tabn, P),
    Pen is Pe + P.
% X = 7
joga_pos((Pe, Pd, Tab), d, 7, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 1),!,
    faz_jogada((Pe, Pd, Tab), 7, Tabn, P),
    Pdn is Pd + P.
% X = 8
joga_pos((Pe, Pd, Tab), d, 8, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 2),!,
    faz_jogada((Pe, Pd, Tab), 8, Tabn, P),
    Pdn is Pd + P.
% X = 9
joga_pos((Pe, Pd, Tab), d, 9, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 3),!,
    faz_jogada((Pe, Pd, Tab), 9, Tabn, P),
    Pdn is Pd + P.
% X = 10
joga_pos((Pe, Pd, Tab), d, 10, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 4),!,
    faz_jogada((Pe, Pd, Tab), 10, Tabn, P),
    Pdn is Pd + P.
% X = 11
joga_pos((Pe, Pd, Tab), d, 11, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 5),!,
    faz_jogada((Pe, Pd, Tab), 11, Tabn, P),
    Pdn is Pd + P.
% X = 12
joga_pos((Pe, Pd, Tab), d, 12, (Pe, Pdn, Tabn)) :-
    lista_lado_d(Tab, Tab_d),
    jogada_valida(Tab_d, 6),!,
    faz_jogada((Pe, Pd, Tab), 12, Tabn, P),
    Pdn is Pd + P.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


oper(E, J, X, En) :-
	joga_pos(E, J, X, En).