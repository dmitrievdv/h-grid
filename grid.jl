using Plots
using Roots
using LaTeXStrings

iteratedhfunc(c, h) = x -> x + c*h(x)

function iteratedfarray(f, n)
    res = zeros(n+1)
    for i = 1:n
        res[i+1] = f(res[i])
    end
    return res
end

function iteratef(f, n)
    res = 0.0
    for i = 1:n
        res = f(res)
    end
    return res
end

function gridend(h, c, n)
    f = iteratedhfunc(c, h)
    iteratef(f, n)
end

function gridarray(h, c, n)
    f = iteratedhfunc(c, h)
    iteratedfarray(f, n)
end

function findc(h, n, a, b)
    c = (a+b)/2
    Δ = b
    f(x) = iteratef(iteratedhfunc(x, h), n) - 1
    c = find_zero(f, (a,b))
    return c
end

function findc(h, n)
    if n == 1
        return 1/h(0)
    end
    a = 0
    b = findc(h, n-1)
    findc(h, n, a, b)
end

function findcarray(h, n)
    cs = zeros(n)
    cs[1] = 1/h(0)
    for i = 2:n
        cs[i] = findc(h, i, 0.0, 1.0)
    end
    return cs
end

function plotgrids(h, n)
    cs = findcarray(h, n)
    plt = plot(xlabel = L"x_n:\ x_{n+1} = x_{n} + c\cdot h(x_n),\ n = 1...N,\ c > 0", ylabel = L"N")
    for i = 1:n
        scatter!(plt, gridarray(h, cs[i], i), fill(i+1,i), label = false, mc = "black")
    end
    plt
end

function plotsolutions(h, n)
    plt = plotgrids(h, n)
    x = [0:0.001:1;]
    plt_h = plot(x, h.(x), ylabel = L"h(x)", xlabel = L"x", label = false)
    plot(plt_h, plt, layout = @layout([A; B]))
end

h = x -> cos(40x)+2.01
plotsolutions(h, 40)