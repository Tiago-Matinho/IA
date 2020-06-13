from pyswip import *
prolog = Prolog()
prolog.consult("alfabeta.pl")


def joga(lista, pos):
    valor = lista[pos]

    i = pos

    lista[pos] = 0

    quociente = int(valor/11)

    resto = valor % 11

    while(valor != 0):
        if(i == pos):
            i -= 1

        if(i == -1):
            i = len(lista) - 1

        lista[i] += quociente
        valor -= quociente
        
        if(resto > 0):
            lista[i] += 1
            resto -= 1
            valor -= 1

        i -= 1
    
    return lista, i + 1

def captura(lista, inicio):
    i = inicio
    pontos = 0

    while(lista[i] == 2 or lista[i] == 3):

        pontos += lista[i]
        lista[i] = 0
        i += 1

        if(i == len(lista)):
            i = 0

    return lista, pontos

def faz_jogada(pos, lado):
    #tirar o tabuleiro
    dic = list(prolog.query("estado_atual(P_e, P_d, Tab)"))[0]
    tabuleiro = dic["Tab"]
    pontos_e = dic["P_e"]
    pontos_d = dic["P_d"]

    pos -= 1
    novo_tab, ultima_pos = joga(tabuleiro, pos)
    novo_tab, pontos = captura(novo_tab, ultima_pos)
    print("DEBUG: " + str(novo_tab) + " fez: " + str(pontos) + " pontos\n")
    
    prolog.retractall("estado_atual(X,Y,Z)")

    if(lado == "e"):
        pontos_e = int(pontos_e) + pontos

    else:
        pontos_d = int(pontos_d) + pontos
    
    prolog.assertz("estado_atual(%d, %d, %s)" % (pontos_e, pontos_d, str(novo_tab)))
faz_jogada.arity = 2

registerForeign(faz_jogada)

def jogadas_validas(lado):
    if(lado == "e"):
        inicio = 6
        fim = 12

    else:
        inicio = 0
        fim = 6

    prolog.retractall("jogada_possivel(X)")

    dic = list(prolog.query("estado_atual(P_e, P_d, Tab)"))[0]
    tabuleiro = dic["Tab"]
    lista = tabuleiro[inicio:fim]

    maximo = int(max(lista))

    if(maximo == 1):
        for i in range(len(lista)):
            if(i != 0):
                prolog.asserta("jogada_possivel(%d)" % (i + 1))

    else:
        for i in range(len(lista)):
            if(i > 1):
                prolog.asserta("jogada_possivel(%d)" % (i + 1))
jogadas_validas.arity = 1

registerForeign(jogadas_validas)

def op(E, J, X):
    prolog.query("jogadas_validas(%s)" %(J))
    prolog.query("jogadas_validas(X), faz_jogada(X,%s)" % (J))

prolog.query("joga(X)")