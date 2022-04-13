
"""
    pairing2(i,j)

The Hopcroft-Ullman pairing function, which bijectively maps two positive integers to a positive integer.

See https://mathworld.wolfram.com/PairingFunction.html
"""
pairing2(i,j) = div((i+j-2)*(i+j-1),2) + i

pairing3(i,j,k) = pairing2(i,pairing2(j,k))

pairing4(i,j,k,l) = pairing2(pairing2(i,j),pairing2(k,l))

pairing5(i,j,k,l,m) = pairing2(pairing2(i,j), pairing3(k,l,m))

pairing6(i,j,k,l,m,n) = pairing2(pairing2(i,j), pairing4(k,l,m,n))

pairing7(i,j,k,l,m,n,o) = pairing2(pairing3(i,j,k), pairing4(l,m,n,o))

pairing8(i,j,k,l,m,n,o,p) = pairing2(pairing4(i,j,k,l), pairing4(m,n,o,p))

