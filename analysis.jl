
using Boltzmann

require("data.jl")


function load_fitted()
    artists = load(ARTIST_FILE)["artists"]
    model = load(MODEL_FILE)["model"]
    return model, artists
end


function most_different(w, artists)
    artists[findin(w, minimum(w))], artists[findin(w, maximum(w))]
end


function artname2id(artists)
    Dict([(a, i) for (i, a) in enumerate(artists)])
end


function mk_axis(w, artists)
    wi = [(w[i], i) for i=1:length(w)]
    idxs = Int32[i for (w, i) in sort(wi)]
    return artists[idxs]
end


function basis_artnames(model, artists)
    W = components(model)
    basis = convert(Array{UTF8String, 2}, zeros(UTF8String, size(W)))
    for j=1:size(W, 2)
        basis[:, j] = mk_axis(W[:, j], artists)
    end
    return basis
end


# Usage: recommend(model, artists, ["my favorite artist", "another good guy", ...])
function recommend(model, artists, pref_artists)
    n_vis = size(components(model), 1)
    pref_vec = zeros(Float64, n_vis)
    name2id = artname2id(artists)
    for art in pref_artists
        pref_vec[name2id[art]] = 1.
    end
    rec_vec = generate(model, pref_vec)
    return artists[findin(rec_vec, 1.)]
end


