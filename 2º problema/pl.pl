:-dynamic(visitados/1).
%Descricao do problema:

bloqueado( (1, 1), (1, 2) ).
bloqueado( (2, 1), (2, 2) ).
bloqueado( (3, 1), (4, 1) ).
bloqueado( (3, 2), (3, 3) ).
bloqueado( (4, 2), (4, 3) ).

%estado_inicial(Estado) -> dimens~ao, pos_actual

estado_inicial([dim(4, 4), (1, 1)]).

%estado_final(Estado)

estado_final([_, (4, 1)]).

%representacao dos operadores
%op(Eact,OP,Eseg,Custo)

%Norte
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], norte, [ dim(Xmax, Ymax), (Xcur, Yn) ], 1) :-
    Yn is Ycur - 1,
    Yn > 0,
    \+bloqueado( (Xcur, Ycur), (Xcur, Yn) ),
    \+bloqueado( (Xcur, Yn), (Xcur, Ycur) ).
%Este
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], este, [ dim(Xmax, Ymax), (Xn, Ycur) ], 1) :-
    Xn is Xcur + 1,
    Xn =< Xmax,
    \+bloqueado( (Xcur, Ycur), (Xn, Ycur) ),
    \+bloqueado( (Xn, Ycur), (Xcur, Ycur) ).
%Sul
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], sul, [ dim(Xmax, Ymax), (Xcur, Yn) ], 1) :-
    Yn is Ycur + 1,
    Yn =< Ymax,
    \+bloqueado( (Xcur, Ycur), (Xcur, Yn) ),
    \+bloqueado( (Xcur, Yn), (Xcur, Ycur) ).
%Oeste
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], oeste, [ dim(Xmax, Ymax), (Xn, Ycur) ], 1) :-
    Xn is Xcur - 1,
    Xn > 0,
    \+bloqueado( (Xcur, Ycur), (Xn, Ycur) ),
    \+bloqueado( (Xn, Ycur), (Xcur, Ycur) ).


%representacao dos nos
%no(Estado,no_pai,Operador,Custo,Profundidade)

pesquisa_local_hill_climbingSemCiclos(E, _) :- 
    retract(visitados(V)),
    V1 is V + 1,
    asserta(visitados(V1)),
	estado_final(E),
	write(E), write(' '),nl,
    write("Total de estados visitados: \t"), write(V1), nl.

pesquisa_local_hill_climbingSemCiclos(E, L) :- 
	write(E), write(' '),
	expande(E,LSeg),
	sort(3, @=<, LSeg, LOrd),
	obtem_no(LOrd, no(ES, Op, _)),
	\+ member(ES, L),
	write(Op), nl,
	(pesquisa_local_hill_climbingSemCiclos(ES,[E|L]) ; write(undo(Op)), write(' '), fail).

expande(E, L):- 
	findall(no(En,Opn, Heur),
                (op(E,Opn,En,_), heur(En, Heur)),
                L).

obtem_no([H|_], H).
obtem_no([_|T], H1) :-
	obtem_no(T, H1).

pesquisa :-
	estado_inicial(S0),
    asserta(visitados(0)),
	pesquisa_local_hill_climbingSemCiclos(S0, []).

%heuristica
heur([_, (Xcur, Ycur)], 0) :-
    estado_final([_, (Xcur, Ycur)]).
heur([_, (Xcur, Ycur)], 1) :-
    \+estado_final([_, (Xcur, Ycur)]).
    