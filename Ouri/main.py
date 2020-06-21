import sys
import time
from pyswip import Prolog
from joga import faz_jogada
from tab import draw_board


def jogada_ia(tabuleiro, primeiro):
    if(primeiro):
        if(max(tabuleiro[:6]) == 0):
            print(0)
            return tabuleiro
    else:
        if(max(tabuleiro[6:]) == 0):
            print(0)
            return tabuleiro

    # insere no prolog o estado inicial
    prolog.retractall("estado_inicial(_)")
    prolog.asserta("estado_inicial([%d, %d, %s])" %(tabuleiro[0], tabuleiro[1], str(tabuleiro[2:])))

    # inicio da contagem do tempo
    start_time = int(time.time() * 1000)

    #query ao prolog
    query = list(prolog.query("joga(X)"))[0]
    escolhaBot = query['X']

    if(escolhaBot == 0):
        print(escolhaBot)
        return tabuleiro

    #faz jogada
    tabuleiro_n, pontos = faz_jogada(tabuleiro[2:], escolhaBot)

    #adiciona pontos
    if(primeiro):   #1º jogador
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)
        print(escolhaBot)

    else:           #2º jogador
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])
        print(escolhaBot - 6)

    #tempo passado
    time_diff = int(time.time() * 1000) - start_time
    print("demorou: " + str(time_diff / 1000))

    draw_board(tabuleiro_n, escolhaBot)
    return tabuleiro_n

def jogada_adv(tabuleiro, primeiro):
    escolha = int(input())  # recebe jogada

    if(escolha == 0):       #nao altera
        return tabuleiro

    if primeiro:            #caso o adversario seja o segundo a jogar
        escolha += 6

    tabuleiro_n, pontos = faz_jogada(tabuleiro[2:], escolha) #efectua a jogada

    #pontos
    if(not primeiro):
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])


    draw_board(tabuleiro, escolha)
    return tabuleiro_n

def vencedor(tabuleiro):
    return (tabuleiro[0] > 24 or tabuleiro[1] > 24)

if __name__ == '__main__':
    prolog = Prolog()
    prolog.consult("base.pl")
    prolog.consult("alfabeta.pl")

    if(sys.argv[1] != "p" and sys.argv[1] != "-p" and
        sys.argv[1] != "s" and sys.argv[1] != "-s"):
        print("Argumentos errados: -p / -s")
        exit(1)

    primeiro = (sys.argv[1] == "p" or sys.argv[1] == "-p")

    if primeiro:
        prolog.asserta("jogador(p1)")
        prolog.consult("1.pl")  #regras para o jogador 1

    else:
        prolog.asserta("jogador(p2)")
        prolog.consult("2.pl")

    if(sys.argv[2] != "1" and sys.argv[2] != "2" and
        sys.argv[2] != "3"):
        print("Argumentos errados: 1 / 2 / 3")
        exit(1)

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

        if(primeiro):
            tabuleiro = jogada_ia(tabuleiro, primeiro)

        tabuleiro = jogada_adv(tabuleiro, primeiro)

        if(not primeiro):
            tabuleiro = jogada_ia(tabuleiro, primeiro)

    if(tabuleiro[0] > 24 and primeiro):
        print("Venci")
    if(tabuleiro[1] > 24 and not primeiro):
        print("Venci")
