import sys

#//TODO Novo nome
def joga(lista, pos):
    pos -= 1
    #distribui sementes
    valor = lista[pos] #numero sementes

    i = pos

    quociente = int(valor/11)
    resto = valor % 11

    #ciclo de distribuicao
    while(valor != 0):
        if(i == pos):
            i += 1
        if(i == len(lista)): #wrap
            i = 0
            if(pos == 0):
                i = 1

        lista[i] += quociente
        valor -= quociente
        if(resto > 0):
            lista[i] += 1
            resto -= 1
            valor -= 1
        i += 1

    #adiciona casa vazia
    lista[pos] = 0

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



if __name__ == '__main__':

    tab = [9, 9, 1, 0, 0, 1, 9, 9, 0, 2, 2, 1]
    x = 2

    lista , pontos = joga(tab, x)

    print(pontos)
    print(lista)