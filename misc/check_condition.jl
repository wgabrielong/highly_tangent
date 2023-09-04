using Combinatorics

function binomial_parity(n::Int, k::Int)
    while k > 0
        if (k & 1) > (n & 1)
            return 0  # Even
        end
        n >>= 1
        k >>= 1
    end
    return 1  # Odd
end

function B(r, m)
        return ((m-1)*binomial(BigInt(m+r-1),BigInt(m-1)))/(r+1)
end

function check_condition(r)
    r_fact = factorial(r)
    for m in 1:factorial(r+1)
        product = 1
        for k in 0:(r-1)
            product *= (m + k)
        end
        if (r^2 * r_fact + product) % factorial(r + 1) == 0
            n = (r^2 * r_fact + product) ÷ factorial(r + 1)
            if r*(n-r)+n - binomial(BigInt(m+r-1), BigInt(r)) == 0
                if ((-m+1)*binomial_parity(m-r-1,r)-r-1) % 2 == 0 && ((B(r,m)-n) % 2 == 0)
                    println("The tuple r = $(r), m = $(m), and n = $(n) describes an orientable bundle of principal parts.")
                else
                    println("The tuple r = $(r), m = $(m), and n = $(n) satisfies congruence and rank but does not define an orientable bundle.") 
                end
            end
        else
            println("The tuple r = $(r), m = $(m), and n = $((r^2 * r_fact + product) ÷ factorial(r + 1)) only satisfies congruence.")
        end
    end
end