import sys

def jogadas_validas(tab, x):
    
    maximo = int(max(tab))

    x -= 1

    if(maximo == 1):
        if tab[x] == 1:
            print("true")
            return
                
    else:
        if tab[x] > 1:
            print("true")
            return
    
    print("false")



if __name__ == '__main__':
    
    #tab = sys.argv[1]
    #x = int(sys.argv[2])

    #tab = list(tab.split(","))
    #tab = list(map(int, tab))

    tab = [1,2,3,4]
    x = 2

    jogadas_validas(tab, x)