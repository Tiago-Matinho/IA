%Descricao do problema:

bloqueado( (1, 1), (1, 2) ).
bloqueado( (2, 1), (2, 2) ).
bloqueado( (3, 1), (4, 1) ).
bloqueado( (3, 2), (3, 3) ).
bloqueado( (4, 2), (4, 3) ).

%estado_inicial(Estado) -> dimens~ao, pos_actual

estado_inicial([dim(4, 4), (1, 1)]).

%estado_final(Estado)

estado_final([_, (4, 4)]).

%representacao dos operadores
%op(Eact,OP,Eseg,Custo)

%Norte
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], norte, [ dim(Xmax, Ymax), (Xcur, Yn) ], 1) :-
    Yn is Ycur - 1,
    Yn > 0,
    \+bloqueado( (Xcur, Ycur), (Xcur, Yn) ),
    \+bloqueado( (Xcur, Yn), (Xcur, Ycur) ).
%Oeste
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], oeste, [ dim(Xmax, Ymax), (Xn, Ycur) ], 1) :-
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
%Este
op( [ dim(Xmax, Ymax), (Xcur, Ycur) ], este, [ dim(Xmax, Ymax), (Xn, Ycur) ], 1) :-
    Xn is Xcur - 1,
    Xn > 0,
    \+bloqueado( (Xcur, Ycur), (Xn, Ycur) ),
    \+bloqueado( (Xn, Ycur), (Xcur, Ycur) ).

%representacao dos nos
%no(Estado,no_pai,Operador,Custo, CustoH, Profundidade)

pesquisa_aux([no(E,Pai,Op,C,CH,P)|_],no(E,Pai,Op,C,CH,P), V, M) :- 
	estado_final(E),
    write("Total de estados visitados: \t"), write(V), nl,
    write("Máximo de estados em memória: \t"), write(M), nl.
pesquisa_aux([E|R],Sol, V, M):- 
	expande(E,Lseg),
        insere_ordenado(Lseg,R,LFinal),
        length(LFinal, Mn),
        max(M, Mn, Mnn),
        Vn is V + 1,
        pesquisa_aux(LFinal,Sol, Vn, Mnn).

expande(no(E,Pai,Op,C,CH,P),L):- 
	findall(no(En,no(E,Pai,Op,C,CH,P), Opn, Cnn, CHn, P1),
                (op(E,Opn,En,Cn), P1 is P+1, Cnn is Cn+C, heur(En,H), CHn is Cnn + H),
                L).

pesquisa :-
	estado_inicial(S0),
	pesquisa_aux([no(S0,[],[],0,0,0)], S, 0, 0),
	escreve_caminho(S).


ins_ord(E, [], [E]).
ins_ord(no(E,Pai,Op,C,CH,P), [no(E1,Pai1,Op1,C1,CH1,P1)|T], [no(E,Pai,Op,C,CH,P),no(E1,Pai1,Op1,C1,CH1,P1)|T]) :- C =< C1.
ins_ord(no(E,Pai,Op,C,CH,P), [no(E1,Pai1,Op1,C1,CH1,P1)|T], [no(E1,Pai1,Op1,C1,CH1,P1)|T1]) :-
	ins_ord(no(E,Pai,Op,C,CH,P), T, T1).	

insere_ordenado([],L,L).
insere_ordenado([A|T], L, LF):- 
	ins_ord(A,L,L1),
	insere_ordenado(T, L1, LF).

escreve_caminho( no(_, [], _, _, _, _) ).
escreve_caminho( no(_, Pai, Op, _, _, _) ) :-
    escreve_caminho(Pai),
    write(" -> "), write(Op).

%heuristica
heur([_, (Xcur, Ycur)], C) :-
    estado_final([_, (Xfin, Yfin)]),
    A is Xfin - Xcur,
    B is Yfin - Ycur,
    abs(A, An),
    abs(B, Bn),
    C is An + Bn.

abs(A, B) :-
    A > 0,!,
    B is A.
abs(A, B) :-
    A =< 0,
    B is 0 - A.

max(A, B, C) :-
    A > B,!,
    C is A.
max(A, B, C) :-
    A < B,!,
    C is B.
max(A, A, A).
