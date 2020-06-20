import sys
from pyswip import Prolog
from joga import joga
from tab import draw


def imprime_tabuleiro(tabuleiro):
    print("Estado python: [" + str(tabuleiro[0]) + ", " + str(tabuleiro[1]) + ", " + str(tabuleiro[2:]) + "]")
    #draw(tabuleiro)



def jogada_bot(tabuleiro, lado):
    if(lado):
        if(max(tabuleiro[:6]) == 0):
            print("Bot escolheu: 0")
            return tabuleiro
    else:
        if(max(tabuleiro[6:]) == 0):
            print("Bot escolheu: 0")
            return tabuleiro

    prolog.retractall("estado_inicial(_)")

    tabuleiro_str = str(tabuleiro[2:])

    prolog.asserta("estado_inicial([%d, %d, %s])" %(tabuleiro[0], tabuleiro[1], tabuleiro_str))

    query = list(prolog.query("joga(X)"))[0]
    escolhaBot = query['X']

    print("Bot escolheu: %d" %(escolhaBot))

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
    prolog.consult("base.pl")
    prolog.consult("alfabeta.pl")

    lado = (sys.argv[1] == "p")

    if lado:
        prolog.asserta("jogador(p1)")
        prolog.consult("1.pl")
    else:
        prolog.asserta("jogador(p2)")
        prolog.consult("2.pl")

    tabuleiro = [0,0,4,4,4,4,4,4,4,4,4,4,4,4]

    flag = True
    while flag:

        if(lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

        tabuleiro = jogada_adv(tabuleiro, lado)

        if(not lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

        t = input("continuar?")

