
using DataFrames
using HDF5, JLD

DATA_DIR = expanduser("~/Dropbox/Data/lastfm-dataset-360K/")
PROFILES_FILE = DATA_DIR * "usersha1-profile.tsv"
FULL_DATASET_FILE = DATA_DIR * "usersha1-artmbid-artname-plays.tsv"
SHORT_DATASET_FILE = DATA_DIR * "short.tsv"
ARTIST_FILE = DATA_DIR * "artists.jld"
USER_FILE = DATA_DIR * "users.jld"
MODEL_FILE = DATA_DIR * "model.jld"
TOPN = 1000
LOW_THRESHOLD = 10

# read full last.fm dataset (17M records)
function read_full_dataset()
    return readtable(FULL_DATASET_FILE, separator='\t', quotemark=Char[],
                     names=[:userid, :artmbid, :artname, :plays])
end

# read top 1K artist dataset (8M)
# unlike read_full_dataset(), this returns preprocessed data
# where artname and user id are replaced with corresponding
# continuous ids
function read_short_dataset()
    return readtable(SHORT_DATASET_FILE, separator='\t')
end

# read user profile data
function read_profiles()
    return readtable(PROFILES_FILE, separator='\t', quotemark=Char[],
                     names=[:userid, :gender, :age, :country, :regdate])
end
