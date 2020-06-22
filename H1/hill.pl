
pesquisa_local_hill_climbingSemCiclos(E, _) :- 
	terminal(E).

pesquisa_local_hill_climbingSemCiclos(E, L) :- 
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
	pesquisa_local_hill_climbingSemCiclos(S0, []),!.

run(N) :-
	faz_tab(N),
	time(pesquisa).


