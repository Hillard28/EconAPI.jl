#==========================================================================================
# EconAPI
# Ryan Gilland
==========================================================================================#
module EconAPI

export
# data.census
    CensusAPI,
    get_data

include("data/census.jl")

end