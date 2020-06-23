import sys
import subprocess
import time
from pyswip import Prolog
from joga import faz_jogada
from tab import draw_board
import tkinter as tk
from tkinter import simpledialog

# cria uma janela para receber inputs do utilizador
def gui_input(img_sp):
    window = tk.Tk()
    window.withdraw()
    escolha = simpledialog.askinteger(title="Escolha",
                                    prompt="Que casa escolhe?")

    if escolha == None:
        img_sp.kill()
        exit(1)
    return escolha

# fecha o subprocesso que abriu a imagem anterior e cria um novo
def gui_display(img_sp):
    img_sp.kill()
    new_img_sp = subprocess.Popen(["display", "Jogada.png"])
    return new_img_sp

# trata da jogada da IA
def jogada_ia(tabuleiro, primeiro, GUI, DISPLAY_TIME):
    if(primeiro):   # sem jogada possivel
        if(max(tabuleiro[:6]) == 0):
            print(0)
            return tabuleiro
    else:           # sem jogada possivel
        if(max(tabuleiro[6:]) == 0):
            print(0)
            return tabuleiro

    # insere no prolog o estado inicial
    prolog.retractall("estado_inicial(_)")
    prolog.asserta("estado_inicial([%d, %d, %s])" %(tabuleiro[0], tabuleiro[1], str(tabuleiro[2:])))

    # inicio dagem do tempo
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
    if(DISPLAY_TIME):
        print("demorou: " + str(time_diff / 1000))

    if(GUI):
        draw_board(tabuleiro_n, escolhaBot)
    return tabuleiro_n

# trata da jogada do adversario
def jogada_adv(tabuleiro, primeiro, img_sp, GUI):
    
    if(GUI):
        escolha = gui_input(img_sp)
    else:
        escolha = int(input())  # recebe jogada

    if(escolha == 0):       # nao altera
        return tabuleiro

    if primeiro:            # caso o adversario seja o segundo a jogar
        escolha += 6

    tabuleiro_n, pontos = faz_jogada(tabuleiro[2:], escolha) # efectua a jogada

    # pontos
    if(not primeiro):
        pontos += tabuleiro[0]
        tabuleiro_n.insert(0, tabuleiro[1])
        tabuleiro_n.insert(0, pontos)

    else:
        pontos += tabuleiro[1]
        tabuleiro_n.insert(0, pontos)
        tabuleiro_n.insert(0, tabuleiro[0])

    if(GUI):
        draw_board(tabuleiro_n, escolha)
    return tabuleiro_n

# verifica se o jogo acabou
def fim_jogo(tabuleiro):
    if(tabuleiro[0] > 24 or tabuleiro[1] > 24):
        return True

    # verifica se existe um loop
    if(max(tabuleiro) == 2):
        for i in range(6):
            if tabuleiro[i] == tabuleiro[i+6] == 1:
                return True

    # verifica se alguem ficou sem jogadas possiveis
    tab1 = tabuleiro[2:8]
    tab2 = tabuleiro[8:]
    if(max(tab1) == 0):
        if(max(tab2) > 1):
            for i in range(len(tab2)):
                if(tab2[i] > 1):
                    possivel_tab, p = faz_jogada(tabuleiro, i+1)
                    if(max(possivel_tab[:6]) == 0):
                        return True
        else:
            if(tab2[5] == 1):
                return True

    if(max(tab2) == 0):
        if(max(tab1) > 1):
            for i in range(len(tab1)):
                if(tab1[i] > 1):
                    possivel_tab, p = faz_jogada(tabuleiro, i+1)
                    if(max(possivel_tab[6:]) == 0):
                        return True
        else:
            if(tab1[5] == 1):
                return True

    return False


if __name__ == '__main__':
    # argumento 1 (algoritmo)
    if(sys.argv[1] != "minimax" and sys.argv[1] != "alfabeta"):
        print("Argumentos errados: -minimax / -alfabeta")
        exit(1)

    # inicializa a ligacao ao prolog
    prolog = Prolog()
    prolog.consult("base.pl")
    prolog.consult(sys.argv[1] + ".pl")
    profundidade = 0

    if(sys.argv[1] == "minimax"):
        profundidade = 1

    # argumento 2 (primeiro ou segundo)
    if(sys.argv[2] != "p" and sys.argv[2] != "-p" and
        sys.argv[2] != "s" and sys.argv[2] != "-s"):
        print("Argumentos errados: -p / -s")
        exit(1)

    primeiro = (sys.argv[2] == "p" or sys.argv[2] == "-p")

    if primeiro:
        prolog.asserta("jogador(p1)")
        prolog.consult("1.pl")  #regras para o jogador 1
    else:
        prolog.asserta("jogador(p2)")
        prolog.consult("2.pl")  #regras para o jogador 2

    # argumento 3 (nivel)
    if(sys.argv[3] != "1" and sys.argv[3] != "2" and
        sys.argv[3] != "3"):
        print("Argumentos errados: 1 / 2 / 3")
        exit(1)
    if(sys.argv[3] == "1"):
        prolog.asserta("profundidade(%d)" %(7 + profundidade))
    elif(sys.argv[3] == "2"):
        prolog.asserta("profundidade(%d)" %(8 + profundidade))
    elif(sys.argv[3] == "3"):
        prolog.asserta("profundidade(%d)" %(9 + profundidade))
    
    # argumento 4 (TEMPO)
    DISPLAY_TIME = False
    if(len(sys.argv) > 4):
        if(sys.argv[4] == "true"):
            DISPLAY_TIME = True
        elif(sys.argv[4] == "false"):
            DISPLAY_TIME = False
        else:
            print("Argumentos errados: true / false")
            exit(1)


    # argumento 5 (GUI)
    GUI = False
    if(len(sys.argv) == 6):
        if(sys.argv[5] == "gui"):
            GUI = True
        elif(sys.argv[5] == "no-gui"):
            GUI = False
        else:
            print("Argumentos errados: gui / no-gui")
            exit(1)

    
    tabuleiro = [0,0,4,4,4,4,4,4,4,4,4,4,4,4]
    img_sp = None

    if(GUI):
        draw_board(tabuleiro, 16)
        img_sp = subprocess.Popen(["display", "Jogada.png"])

    # ciclo principal
    while True:
        if(primeiro):
            tabuleiro = jogada_ia(tabuleiro, primeiro, GUI, DISPLAY_TIME)
            if(GUI):
                img_sp = gui_display(img_sp)

            if(fim_jogo(tabuleiro)):
                break

        tabuleiro = jogada_adv(tabuleiro, primeiro, img_sp, GUI)
        if(GUI):
            img_sp = gui_display(img_sp)

        if(fim_jogo(tabuleiro)):
            break

        if(not primeiro):
            tabuleiro = jogada_ia(tabuleiro, primeiro, GUI, DISPLAY_TIME)
            if(GUI):
                img_sp = gui_display(img_sp)
    
            if(fim_jogo(tabuleiro)):
                break

    # fim de jogo
    if(tabuleiro[0] < 24 and tabuleiro[1] < 24):
        for i in range(6):
            tabuleiro[0] += tabuleiro[2 + i]
            tabuleiro[1] += tabuleiro[8 + i]

    if(tabuleiro[0] > tabuleiro[1] and primeiro):
        print("ganhei!")
    elif(tabuleiro[1] > tabuleiro[0] and not primeiro):
        print("ganhei!")
    else:
        print("perdi!")

    if(GUI):
        img_sp.kill()
