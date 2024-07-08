using DataFrames
include("../src/EconAPI.jl")
using .EconAPI

if ENV["USER"] == "ryangilland"
    dir = "/home/ryangilland/Projects/EconAPI.jl/"
end

key = read(dir * "testing/census_api_key.txt", String)
capi = CensusAPI(key)

headers, data = get_data(
    capi;
    source="dec",
    product="ddhca",
    year=2020,
    variables="NAME",
    geographical_level="county",
    geographies="*"
)

data[2] = parse.(Int64, data[2])
data[3] = parse.(Int64, data[3])

df = DataFrame(data, headers)
df = identity.(df)
