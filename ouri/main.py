import sys
from pyswip import Prolog

#//TODO Novo nome
def joga(lista, pos):
    pos -= 1
    #distribui sementes
    valor = lista[pos] #numero sementes
    i = pos
    lista[pos] = 0
    quociente = int(valor/11)
    resto = valor % 11
    #ciclo de distribuicao
    while(valor != 0):
        if(i == pos):   #wrap
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
    #captura
    i += 1
    pontos = 0
    #ciclo de captura
    while(lista[i] == 2 or lista[i] == 3):
        pontos += lista[i]
        lista[i] = 0
        i += 1
        if(i == len(lista)): #wrap
            i = 0
    
    return lista, pontos

def jogada_prolog(tabuleiro, pos):
    lista, pontos = joga(tabuleiro, pos)
    lista_str = str(lista).replace(" ", "") #limpa str para o prolog
    lista_str = lista_str[1:-1] + "\n" + str(pontos)
    print(lista_str)

def imprime_tabuleiro(tabuleiro):
    print("Pontos esquerda: ")
    print(tabuleiro[0])
    print("Pontos direita: ")
    print(tabuleiro[1])
    print("Tabuleiro: ")
    print(tabuleiro[2:])

def argumentos():
    lado = ""
    
    while lado != "e" and lado != "d":
        lado = input("Qual o meu lado 'e' ou 'd'?\n-> ")

    lado = (lado == "e")

    return lado
    
def jogada_bot(tabuleiro, lado):
    prolog.retractall("estado_atual(_)")
    prolog.retractall("estado_inicial(_)")

    tabuleiro_str = str(tabuleiro[2:])

    prolog.asserta("estado_inicial((%d, %d, %s))" %(tabuleiro[0], tabuleiro[1], tabuleiro_str))

    prolog.asserta("estado_atual((%d, %d, %s))" %(tabuleiro[0], tabuleiro[1], tabuleiro_str))

    query = list(prolog.query("joga(X,V)"))[0]
    escolhaBot = query['X']
    visitados = query['V']

    print("Bot escolheu: %d depois de visitar %d nós" %(escolhaBot, visitados))

    tabuleiro_n, pontos = joga(tabuleiro[2:], escolhaBot)

    if(lado):
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])

    imprime_tabuleiro(tabuleiro_n)

    return tabuleiro_n

def jogada_adv(tabuleiro, lado):
    escolha = input("que casa escolhes?\n-> ")

    tabuleiro_n, pontos = joga(tabuleiro[2:], escolha)

    if(not lado):
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])

    imprime_tabuleiro(tabuleiro_n)

    return tabuleiro_n

if __name__ == '__main__':
    prolog = Prolog()
    prolog.consult("teste.pl")
    prolog.consult("alfabeta.pl")

    lado = argumentos()

    if lado:
        prolog.asserta("jogador(e)")
    else:
        prolog.asserta("jogador(d)")

    tabuleiro = [0,0,4,4,4,4,4,4,4,4,4,4,4,4]

    flag = True
    while flag:

        if(lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

        tabuleiro = jogada_adv(tabuleiro, lado)

        if(not lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

        parar = input("parar (s/n)?\n-> ")

        if parar == "s":
            flag = False

