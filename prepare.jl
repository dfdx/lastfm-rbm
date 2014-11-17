
# Data preprocessing, normalization and all such stuff
# Use `prepare()` to create normalized top N dataset and mappings

using DataFrames

require("data.jl")

function count_by(dataset, col)
    counts = Dict{Any, Int64}()
    for i=1:nrow(dataset)
        val = dataset[i, col]
        if haskey(counts, val)
            counts[val] += 1
        else
            counts[val] = 1
        end
    end
    return counts
end


function most_popular(dataset, col, n=1000)
    # take rows of n most popular (most frequent) col values
    val2count = count_by(dataset, col)
    count2val = [(v, k) for (k, v) in val2count]
    top_n_vals = Set([v for (k, v) in sort(count2val, rev=true)[1:n]])
    rows = Int64[]
    for i=1:nrow(dataset)
        if in(dataset[i, col], top_n_vals)
            push!(rows, i)
        end
    end
    return dataset[rows, :]    
end


function filter_low(dataset, threshold)
    return dataset[dataset[:plays] .>= threshold, :]
end


function normalize_dataset(dataset)
    uid2userid = sort(unique(dataset[:userid]))
    userid2uid = Dict([(uid2userid[i], i) for i=1:length(uid2userid)])
    dataset[:uid] = zeros(Int32, nrow(dataset))
    for i=1:nrow(dataset)
        dataset[i, :uid] = userid2uid[dataset[i, :userid]]        
    end
    delete!(dataset, :userid)
    
    aid2artname = sort(unique(dataset[:artname]))
    artname2aid = Dict([(aid2artname[i], i) for i=1:length(aid2artname)])
    dataset[:aid] = zeros(Int32, nrow(dataset))
    for i=1:nrow(dataset)
        dataset[i, :aid] = artname2aid[dataset[i, :artname]]        
    end
    delete!(dataset, :artname)
    delete!(dataset, :artmbid)
    return dataset, uid2userid, userid2uid, aid2artname, artname2aid
end


function prepare()
    println("Reading full dataset")
    @time df = read_full_dataset()
    println("Collecting most popular artists")
    @time df = most_popular(df, :artname, TOPN)
    println("Filtering out records with too little plays")
    df = filter_low(df, LOW_THRESHOLD)
    println("Normalizing dataset")
    @time norm_dat = normalize_dataset(df)
    println("Saving")
    @time begin
        writetable(SHORT_DATASET_FILE, norm_dat[1], separator='\t')
        save(ARTIST_FILE, "artists", norm_dat[4])
        save(USER_FILE, "users", norm_dat[2])
    end
end


