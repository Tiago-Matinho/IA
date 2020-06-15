import sys

#//TODO Novo nome
def joga(lista, pos):
    pos -= 1
    #distribui sementes
    valor = lista[pos] #numero sementes
    i = pos
    del lista[pos] #remove as sementes

    quociente = int(valor/11)
    resto = valor % 11

    #ciclo de distribuicao
    while(valor != 0):
        if(i == len(lista)): #wrap
            i = 0

        lista[i] += quociente
        valor -= quociente
        if(resto > 0):
            lista[i] += 1
            resto -= 1
            valor -= 1
        i += 1

    #adiciona casa vazia
    lista.insert(pos, 0)

    i -= 1 #ultima posicao tocada

    if(pos < 6 and i < 6) or (pos >= 6 and i >= 6):
        return lista, 0

    #captura
    pontos = 0
    #ciclo de captura
    while(lista[i] == 2 or lista[i] == 3):
        pontos += lista[i]
        lista[i] = 0
        i -= 1
        if(i == -1): #wrap
            i = len(lista) - 1
    
    return lista, pontos

def jogada_prolog(tabuleiro, pos):
    lista, pontos = joga(tabuleiro, pos)
    lista_str = str(lista).replace(" ", "") #limpa str para o prolog
    lista_str = lista_str[1:-1] + "\n" + str(pontos)
    print(lista_str)


"""
//TODO melhoria?
def jogadas_validas(lado):
    if(lado == "e"):
        inicio = 6
        fim = 12

    else:
        inicio = 0
        fim = 6

    prolog.retractall("jogada_possivel(X)")

    dic = list(prolog.query("estado_atual((P_e, P_d, Tab))"))[0]
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
"""

if __name__ == '__main__':
    
    Pe = int(sys.argv[1])
    Pd = int(sys.argv[2])
    tab = sys.argv[3]
    x = int(sys.argv[4])

    tab = list(tab.split(","))
    tab = list(map(int, tab))

    #tab = [2, 1, 1, 0, 8, 7, 7, 7, 2, 7, 1, 3]
    #x = 12

    jogada_prolog(tab, x)