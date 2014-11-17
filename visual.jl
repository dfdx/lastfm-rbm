
using DataFrames
using Gadfly

applyby(df, gcol, fcol, fn) = by(df, gcol, g -> fn(g[fcol]))

function plotby(df, gcol, fcol, fn; ylabel=nothing)
    grouped = applyby(df, gcol, fcol, fn)
    ylabel = ylabel == None ? ylabel : string(fn)
    plot(grouped, x=gcol, y=:x1,
         Guide.XLabel(string(gcol)), Guide.YLabel(ylabel))
end

histogram(ser) = plot(x=ser, Geom.histogram(bincount=300))



function most_popular_hist()
    df = read_full_dataset()
    cnt = count_by(df, :artname)
    cnt2artname = [(cnt[k], k) for k in keys(cnt)]
    cnt2artname = sort(cnt2artname, rev=true)
    plot(x=1:10000, y=map(first, cnt2artname)[1:10000], Geom.bar,
         Guide.XLabel("most popular artists"), Guide.YLabel("users"))
    return cnt2artname
end
