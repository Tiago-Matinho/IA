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


pesquisa_aux([no(E,Pai,Op,C,P)|_],no(E,Pai,Op,C,P), _, V, M) :- 
	estado_final(E),
    write("Total de estados visitados: \t"), write(V), nl,
    write("Máximo de estados em memória: \t"), write(M), nl.
pesquisa_aux([no(E,Pai,Op,C,P)|R],Sol, LE, V, M):- 
	\+ member(E, LE),
	expande(no(E,Pai,Op,C,P),Lseg),
        insere_inicio(Lseg,R,LFinal),
        length(LFinal, Mn),
        max(M, Mn, Mnn),
        Vn is V + 1,
        pesquisa_aux(LFinal,Sol, [E|LE], Vn, Mnn).
pesquisa_aux([no(E,_,_,_,_)|R],Sol, LE, V, M):- 
	member(E, LE),
        pesquisa_aux(R,Sol, LE, V, M).


expande(no(E,Pai,Op,C,P),L):- 
	findall(no(En,no(E,Pai,Op,C,P), Opn, Cnn, P1),
                (op(E,Opn,En,Cn), P1 is P+1, Cnn is Cn+C),
                L).

pesquisa :-
	estado_inicial(S0),
	pesquisa_aux([no(S0,[],[],0,0)], S, [], 0, 0),
	escreve_caminho(S).

insere_inicio(A,B,C) :- append(A, B, C).

insere_fim(A,B,C) :- append(B, A, C).

escreve_caminho( no(_, [], _, _, _) ).
escreve_caminho( no(_, Pai, Op, _, _) ) :-
    escreve_caminho(Pai),
    write(" -> "), write(Op).

max(A, B, C) :-
    A > B,!,
    C is A.
max(A, B, C) :-
    A < B,!,
    C is B.
max(A, A, A).
