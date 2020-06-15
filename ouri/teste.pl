%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:-dynamic(estado_inicial/1).
:-dynamic(estado_atual/1).
:-dynamic(escolha/1).


%recebe os tabuleiros e os pontos q ganhou. Os tabuleiros atuais são passados
%com o estado atual, a jogada com a jogada possivel
recebe_jogada(Tabn, P) :- %//TODO é preciso os pontos da esquerda e direita?
    estado_atual((Pp, Ps, Tab)),
    atomics_to_string(Tab, ",", Tabstr),
    escolha(Es),
    process_create(path('python3.8'), ['joga.py', Pp, Ps, Tabstr, Es], [stdout(pipe(In))]),
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


valor((X, _, _), 1000) :- X @> 24, jogador(p).
valor((_, X, _), 1000) :- X @> 24, jogador(s).
valor((_, X, _), -1000) :- X @> 24, jogador(p).
valor((X, _, _), -1000) :- X @> 24, jogador(s).
valor((X, _, _), X).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lista_primeiro([A, B, C, D, E, F |_], [A, B, C, D, E, F]).
lista_segundo([_, _, _, _, _, _ |T], T).

maximo_lista([], -1).
maximo_lista([H|T], M) :-
    maximo_lista(T, A),
    M is max(H, A).


jogada_valida(L, X) :-
    atomics_to_string(L, ",", Tabstr),
    process_create(path('python3.8'), ['jogada_valida.py', Tabstr, X], [stdout(pipe(In))]),
    read_string(In, _, "true\n").


%jogada_valida(L, X) :-
%    maximo_lista(L, Max),
%    Max = 1, !,
%    nth1(X, L, Val),
%    Val = 1.
%jogada_valida(L, X) :-
%    nth1(X, L, Val),
%    Val @> 1.

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
oper((Pp, Ps, Tab), p, 1, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 1),!,
    faz_jogada((Pp, Ps, Tab), 1, Tabn, P),
    Ppn is Pp + P.
% X = 2
oper((Pp, Ps, Tab), p, 2, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 2),!,
    faz_jogada((Pp, Ps, Tab), 2, Tabn, P),
    Ppn is Pp + P.
% X = 3
oper((Pp, Ps, Tab), p, 3, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 3),!,
    faz_jogada((Pp, Ps, Tab), 3, Tabn, P),
    Ppn is Pp + P.
% X = 4
oper((Pp, Ps, Tab), p, 4, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 4),!,
    faz_jogada((Pp, Ps, Tab), 4, Tabn, P),
    Ppn is Pp + P.
% X = 5
oper((Pp, Ps, Tab), p, 5, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 5),!,
    faz_jogada((Pp, Ps, Tab), 5, Tabn, P),
    Ppn is Pp + P.
% X = 6
oper((Pp, Ps, Tab), p, 6, (Ppn, Ps, Tabn)) :-
    lista_primeiro(Tab, Tab_p),
    jogada_valida(Tab_p, 6),!,
    faz_jogada((Pp, Ps, Tab), 6, Tabn, P),
    Ppn is Pp + P.
% X = 7
oper((Pp, Ps, Tab), s, 7, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 1),!,
    faz_jogada((Pp, Ps, Tab), 7, Tabn, P),
    Psn is Ps + P.
% X = 8
oper((Pp, Ps, Tab), s, 8, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 2),!,
    faz_jogada((Pp, Ps, Tab), 8, Tabn, P),
    Psn is Ps + P.
% X = 9
oper((Pp, Ps, Tab), s, 9, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 3),!,
    faz_jogada((Pp, Ps, Tab), 9, Tabn, P),
    Psn is Ps + P.
% X = 10
oper((Pp, Ps, Tab), s, 10, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 4),!,
    faz_jogada((Pp, Ps, Tab), 10, Tabn, P),
    Psn is Ps + P.
% X = 11
oper((Pp, Ps, Tab), s, 11, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 5),!,
    faz_jogada((Pp, Ps, Tab), 11, Tabn, P),
    Psn is Ps + P.
% X = 12
oper((Pp, Ps, Tab), s, 12, (Pp, Psn, Tabn)) :-
    lista_segundo(Tab, Tab_d),
    jogada_valida(Tab_d, 6),!,
    faz_jogada((Pp, Ps, Tab), 12, Tabn, P),
    Psn is Ps + P.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
