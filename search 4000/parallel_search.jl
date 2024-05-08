using Distributed
using Combinatorics
using Printf

search_cap_r = 5000
search_cap_m = 5000
search_cap_n = 5000

cpu_info = Sys.cpu_info()

CPU_Cores = Sys.CPU_THREADS
println("Number of CPU cores: ", CPU_Cores)
addprocs(CPU_Cores)

@everywhere begin
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
    
    function A(r,m)
        return binomial_parity((m+r-1), (m-1))
    end
    
    function B(r,m)
        return binomial_parity((m+r-1), (m-2))
    end
    

    function find_solutions(max_r, max_n, m)
        solutions = []
        for n in 1:max_n-1
            for r in 1:min(n-1, max_r+1)
                dim_G = r*(n-r)+n # dimension of the moduli space
                rk_P = binomial(BigInt(m+r-1),BigInt(r)) # rank of the bundle
                if dim_G == rk_P && (m*A(r,m) - (r+1)*(B(r,m) - 1)) % 2 == 0 && (B(r,m) - n) % 2 == 0
                    solution = (m, r, m, n)
                    push!(solutions, solution)
                    open("progress_search.txt", "a") do f
                        write(f, "Process $(myid()) found solution: $solution \n")
                    end
                elseif dim_G == rk_P && ((m+1)*A(r,m) - (r+1)*(B(r,m) - 1)) % 2 == 0 && (B(r,m) - n) % 2 == 0
                    solution = (m+1,r,m,n)
                    push!(solutions, solution)
                    open("progress_search.txt", "a") do f
                        write(f, "Process $(myid()) found solution: $solution \n")
                    end
                end
            end
        end
        if m % 100 == 0
            open("progress_search.txt", "a") do f
                write(f, "Process $(myid()) checked up to $m \n")
            end
        end
        return solutions
    end
end

function find_solutions_parallel(max_r, max_n, max_m)
    result = @distributed (vcat) for m in 1:max_m-1
        find_solutions(max_r, max_n, m)
    end
    return result
end

function convert_seconds(seconds)
    hours = floor(seconds / 3600)
    minutes = floor((seconds % 3600) / 60)
    seconds = seconds % 60
    return (hours, minutes, seconds)
end

start_time = time()
elapsed_time = @elapsed solutions = find_solutions_parallel(search_cap_r, search_cap_n, search_cap_m)
end_time = time()

elapsed_time_hms = convert_seconds(elapsed_time)

open("result_search.txt", "w") do io
    write(io, "Number of CPU cores: $(Sys.CPU_THREADS)\n")
    write(io, "CPU information:\n")
    
    for info in cpu_info
        write(io, @sprintf("  model: %s, speed: %s MHz\n", info.model, info.speed))
    end
    write(io, "Number of CPU cores: $(Sys.CPU_THREADS)\n")
    write(io, "Elapsed time: $(elapsed_time_hms[1]) hours, $(elapsed_time_hms[2]) minutes, and $(elapsed_time_hms[3]) seconds\n")
    write(io, "Results:\n$solutions")
end

