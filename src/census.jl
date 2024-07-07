using HTTP
using JSON3
using JSONTables
using DataFrames

#headers = ["key" => "81bd61bf2cb608b59d5251e583488131b0e15f3d"]
#params = ["type" => "prematch"]

convert_types = true

key = "81bd61bf2cb608b59d5251e583488131b0e15f3d"

uri = "https://api.census.gov/data/2020/dec/ddhca?"
vars = "NAME"
geo = "county:*"

add = uri * "get=" * vars * "&for=" * geo * "&key=" * key

#res = HTTP.get(uri, query = params, headers = headers)
res = HTTP.get(add)
json = JSON3.read(res.body)

num_obs = length(json[2:end])
num_vars = length(json[1])

headers = Vector{String}(undef, num_vars)
types = Vector{Type}(undef, num_vars)
for i = 1:num_vars
    headers[i] = json[1][i]
    types[i] = String
end
data = Vector{Vector{Any}}(undef, num_vars)
for j = 1:num_vars
    data[j] = Vector{Any}(undef, num_obs)
    for i = 1:num_obs
        data[j][i] = json[i+1][j]
    end
end
if convert_types == true
    data[2] = parse.(Int64, data[2])
    data[3] = parse.(Int64, data[3])
end

df = DataFrame(data, headers)
df = identity.(df)
