
using DataFrames
using Boltzmann

require("data.jl")

function play_matrix(dat)    
    n_artists = maximum(dat[:aid])
    n_users = maximum(dat[:uid])
    return sparse(dat[:aid], dat[:uid], dat[:plays], n_artists, n_users)
end


function fit_and_save()
    println("Reading short dataset")
    @time dat = read_short_dataset()
    println("Data size: $(size(dat))")
    println("Building play matrix")
    @time pmat = play_matrix(dat)
    pmat = float(pmat .> 0)
    println("Creating model")
    m = BernoulliRBM(TOPN, int(floor(TOPN / 10)))
    @time fit(m, pmat)
    save(MODEL_FILE, "model", m)
    return m
end





