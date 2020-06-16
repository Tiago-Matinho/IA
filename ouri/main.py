import sys
from pyswip import Prolog
from joga import joga



def imprime_tabuleiro(tabuleiro):
    print("Pontos esquerda: ")
    print(tabuleiro[0])
    print("Pontos direita: ")
    print(tabuleiro[1])
    print("Tabuleiro: ")
    print(tabuleiro[2:])

def argumentos():
    lado = ""
    
    while lado != "p" and lado != "s":
        lado = input("Primeiro ou segundo: 'p' ou 's'?\n-> ")

    lado = (lado == "p")

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
    escolha = int(input("que casa escolhes?\n-> "))

    if lado:
        escolha += 6

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
        prolog.asserta("jogador(p)")
    else:
        prolog.asserta("jogador(s)")

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

