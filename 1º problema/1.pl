%Descricao do problema:

%estado_inicial(Estado)
estado_inicial([tamanho(4, 4), (1, 1)]).
bloqueado( (1, 1), (1, 2) ).
bloqueado( (2, 1), (2, 2) ).
bloqueado( (3, 1), (4, 1) ).
bloqueado( (3, 2), (3, 3) ).
bloqueado( (4, 2), (4, 3) ).


%estado_final(Estado)
estado_final([_, (4, 4)]).