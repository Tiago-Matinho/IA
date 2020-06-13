%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-dynamic(estado_atual/3).
:-dynamic(jogada_possivel/1).
jogada_possivel(9).
estado_atual(0, 0, [1,2,1,3,1,2,1,0,7,0,2,0]).

%recebe os tabuleiros e os pontos q ganhou. Os tabuleiros atuais são passados
%com o estado atual, a jogada com a jogada possivel
recebe_jogada(Tabn, P) :-
    process_create(path('python3.8'), ['joga.py'], [stdout(pipe(In))]),
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



