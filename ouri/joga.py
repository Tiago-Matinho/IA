import sys

#//TODO Novo nome
def joga(lista, pos):
    pos -= 1
    #distribui sementes
    valor = lista[pos] #numero sementes

    i = pos

    quociente = int(valor/11)
    resto = valor % 11

    ultima = pos - 1

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
            ultima = i
        i += 1

    #adiciona casa vazia
    lista[pos] = 0

    #print(lista)

    #ultima = i - 1 #ultima posicao tocada

    #print(ultima)

    if(pos < 6):
        if(ultima < 6):
            return lista, 0 #nao captura
        lista_aux = lista[6:] #lado do adv
        ultima -= 6
        #print(lista_aux)
        #print(ultima)
    else:
        if(ultima >= 6):
            return lista, 0
        lista_aux = lista[:6]
        #print(lista_aux)
        #print(ultima)
    
    #ciclo captura
    cur = lista_aux[ultima]
    pontos = 0

    while(cur == 2 or cur == 3):
        pontos += cur
        lista_aux[ultima] = 0
        ultima -= 1
        if(ultima == -1):
            break
        cur = lista_aux[ultima]

    if(pos < 6):
        ret = lista[:6] + lista_aux
    else:
        ret = lista_aux + lista[6:]

    return ret, pontos

if __name__ == '__main__':

    tab = [9, 3, 1, 0, 2, 1, 1, 12, 11, 0, 0, 0]

    #print(tab)
    x = 3 + 6
    
    lista , pontos = joga(tab, x)

    print(pontos)
    print(lista)