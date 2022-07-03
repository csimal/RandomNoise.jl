
"""
    pairing2(i,j)

The Hopcroft-Ullman pairing function, which bijectively maps two positive integers to a positive integer.

See https://mathworld.wolfram.com/PairingFunction.html
"""
@inline pairing2(i,j) = div((i+j-2)*(i+j-1),2) + i

@inline pairing3(i,j,k) = pairing2(pairing2(i,j),k)

@inline pairing4(i,j,k,l) = pairing2(pairing2(i,j),pairing2(k,l))

@inline pairing5(i,j,k,l,m) = pairing2(pairing2(i,j), pairing3(k,l,m))

@inline pairing6(i,j,k,l,m,n) = pairing2(pairing2(i,j), pairing4(k,l,m,n))

@inline pairing7(i,j,k,l,m,n,o) = pairing2(pairing3(i,j,k), pairing4(l,m,n,o))

@inline pairing8(i,j,k,l,m,n,o,p) = pairing2(pairing4(i,j,k,l), pairing4(m,n,o,p))

function pairing(idx...)
    x = [idx...]
    n = length(x)
    while n > 1
        k = div(n,2)
        for i in 1:k
            x[i] = pairing2(x[2i-1], x[2i])
        end
        if isodd(n)
            x[k+1] = x[n]
            n = k+1
        else
            n = k
        end
    end
    return x[1]
end

pairing(t::Tuple{Vararg{Integer,N}}) where N = pairing(t...)