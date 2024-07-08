using HTTP
using JSON3

mutable struct CensusAPI
    key::String
end

function get_data(
    host;
    source="dec",
    product="ddhca",
    year=2010,
    variables="NAME",
    geographical_level="county",
    geographies="*"
)

    uri = "https://api.census.gov/data/" *
          string(year) * "/" *
          source * "/" *
          product * "?" * "get=" *
          variables * "&for=" *
          geographical_level * ":" *
          geographies * "&key=" *
          host.key

    json = HTTP.get(uri)
    json = JSON3.read(json.body)

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

    return headers, data
end
