import sys
from PIL import Image
from pyswip import Prolog
from joga import joga
from tab import draw
import time


def jogada_bot(tabuleiro, lado):
    if(lado):
        if(max(tabuleiro[:6]) == 0):
            print(0)
            return tabuleiro
    else:
        if(max(tabuleiro[6:]) == 0):
            print(0)
            return tabuleiro

    prolog.retractall("estado_inicial(_)")

    prolog.asserta("estado_inicial([%d, %d, %s])" %(tabuleiro[0], tabuleiro[1], str(tabuleiro[2:])))

    start_time = int(time.time() * 1000) #tempo

    #query ao prolog
    query = list(prolog.query("joga(X)"))[0]
    escolhaBot = query['X']

    print(escolhaBot)
    if(escolhaBot == 0):
        return tabuleiro

    #faz jogada do bot
    tabuleiro_n, pontos = joga(tabuleiro[2:], escolhaBot)

    #adiciona pontos
    if(lado):   #1º jogador
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:       #2º jogador
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])

    #tempo passado
    time_diff = int(time.time() * 1000) - start_time
    print("demorou: " + str(time_diff / 1000))

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

    return tabuleiro_n

def vencedor(tabuleiro):
    if(tabuleiro[0] > 24):
        print("Jogador 1 venceu!")
        return True
    elif(tabuleiro[1] > 24):
        print("Jogador 2 venceu!")
        return True
    return False

if __name__ == '__main__':
    prolog = Prolog()
    prolog.consult("base.pl")
    prolog.consult("alfabeta.pl")

    lado = (sys.argv[1] == "p")

    if lado:
        prolog.asserta("jogador(p1)")
        prolog.consult("1.pl")  #regras para o jogador 1

    else:
        prolog.asserta("jogador(p2)")
        prolog.consult("2.pl")

    if(sys.argv[2] == "1"):
        prolog.asserta("profundidade(7)")
    elif(sys.argv[2] == "2"):
        prolog.asserta("profundidade(8)")
    elif(sys.argv[2] == "3"):
        prolog.asserta("profundidade(9)")
    
    tabuleiro = [0,0,4,4,4,4,4,4,4,4,4,4,4,4]

    while True:
        if(vencedor(tabuleiro)):
            break

        if(lado):
            tabuleiro = jogada_bot(tabuleiro, lado)
            draw(tabuleiro)

        tabuleiro = jogada_adv(tabuleiro, lado)
        draw(tabuleiro)

        if(not lado):
            tabuleiro = jogada_bot(tabuleiro, lado)
            draw(tabuleiro)
