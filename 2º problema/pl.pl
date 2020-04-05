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

estado_final([_, (1, 4)]).

%representacao dos operadores
%op(Eact,OP,Eseg,Custo)

%Norte
op( [ dim(Ymax, Xmax), (Ycur, Xcur) ], norte, [ dim(Ymax, Xmax), (Yn, Xcur) ], 1) :-
    Yn is Ycur - 1,
    Yn > 0,
    \+bloqueado( (Ycur, Xcur), (Yn, Xcur) ),
    \+bloqueado( (Yn, Xcur), (Ycur, Xcur) ).
%Este
op( [ dim(Ymax, Xmax), (Ycur, Xcur) ], este, [ dim(Ymax, Xmax), (Ycur, Xn) ], 1) :-
    Xn is Xcur + 1,
    Xn =< Xmax,
    \+bloqueado( (Ycur, Xcur), (Ycur, Xn) ),
    \+bloqueado( (Ycur, Xn), (Ycur, Xcur) ).
%Sul
op( [ dim(Ymax, Xmax), (Ycur, Xcur) ], sul, [ dim(Ymax, Xmax), (Yn, Xcur) ], 1) :-
    Yn is Ycur + 1,
    Yn =< Ymax,
    \+bloqueado( (Ycur, Xcur), (Yn, Xcur) ),
    \+bloqueado( (Yn, Xcur), (Ycur, Xcur) ).
%Oeste
op( [ dim(Ymax, Xmax), (Ycur, Xcur) ], oeste, [ dim(Ymax, Xmax), (Ycur, Xn) ], 1) :-
    Xn is Xcur - 1,
    Xn > 0,
    \+bloqueado( (Ycur, Xcur), (Ycur, Xn) ),
    \+bloqueado( (Ycur, Xn), (Ycur, Xcur) ).


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
heur([_, (Ycur, Xcur)], 0) :-
    estado_final([_, (Ycur, Xcur)]).
heur([_, (Ycur, Xcur)], 1) :-
    \+estado_final([_, (Ycur, Xcur)]).
    