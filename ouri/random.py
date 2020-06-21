import sys
from PIL import Image
from pyswip import Prolog
from joga import joga
from tab import draw
import time
import random


def jogada_bot(tabuleiro, lado):
    if(lado):
        if(max(tabuleiro[:6]) == 0):
            print(0)
            return tabuleiro
    else:
        if(max(tabuleiro[6:]) == 0):
            print(0)
            return tabuleiro

    escolhaBot = random.randint(1,6)
    while(True):
        if max(tabuleiro[2:]) == 1:
            if tabuleiro[escolhaBot + 1] == 1:
                break
        else:
            if tabuleiro[escolhaBot + 1] > 1:
                break

    #faz jogada do bot
    tabuleiro_n, pontos = joga(tabuleiro[2:], escolhaBot)

    #adiciona pontos
    if(lado):   #1º jogador
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)
        print(escolhaBot)

    else:       #2º jogador
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])
        print(escolhaBot - 6)

    draw(tabuleiro_n, escolhaBot)
    return tabuleiro_n

def jogada_adv(tabuleiro, lado):
    escolha = int(input()) # recebe jogada

    if(escolha == 0):   #nao altera
        return tabuleiro

    if lado:    #caso o adversario seja o segundo a jogar
        escolha += 6

    tabuleiro_n, pontos = joga(tabuleiro[2:], escolha) #efectua a jogada

    #pontos
    if(not lado):
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])


    draw(tabuleiro, escolha)
    return tabuleiro_n

def vencedor(tabuleiro):
    if(tabuleiro[0] > 24):
        return True
    elif(tabuleiro[1] > 24):
        return True
    return False

if __name__ == '__main__':
    prolog = Prolog()
    prolog.consult("base.pl")
    prolog.consult("alfabeta.pl")

    lado = (sys.argv[1] == "p")

    tabuleiro = [0,0,4,4,4,4,4,4,4,4,4,4,4,4]

    while True:
        if(vencedor(tabuleiro)):
            break

        if(lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

        tabuleiro = jogada_adv(tabuleiro, lado)

        if(not lado):
            tabuleiro = jogada_bot(tabuleiro, lado)

    if(tabuleiro[0] > 24 and lado):
        print("Venci")
    if(tabuleiro[1] > 24 and not lado):
        print("Venci")