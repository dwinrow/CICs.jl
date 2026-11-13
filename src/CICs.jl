module CICs

using Countries
using JSON

# Handles Complementary Identification Codes (CICs)

export CIC, category, subcategory, country

struct CIC
    cic::AbstractString
end

# 1. Locate the JSON file relative to this source file
const fdpath = joinpath(@__DIR__, "..", "data", "firstdigit.json")
const sdpath = joinpath(@__DIR__, "..", "data", "seconddigit.json")

# 2. Tell Julia to watch this file for changes (triggers automatic re-compilation if modified)
include_dependency(fdpath)
include_dependency(sdpath)

# 3. Parse the data directly into a compile-time constant
const FIRSTDIGIT = JSON.parsefile(fdpath)
const SECONDDIGIT = reshape(JSON.parsefile(sdpath),(9,16))

category(cic::CIC) = FIRSTDIGIT[parse(Int, cic.cic[3], base=16)]
subcategory(cic::CIC) = SECONDDIGIT[parse(Int, cic.cic[4]),parse(Int, cic.cic[3], base=16)]
country(cic::CIC) = try get_country(cic.cic[1:2]) catch e; missing end

# Location of EIOPA's CIC Excel file in 'xls' format
# https://register.eiopa.europa.eu/Publications/Consultations/EIOPA-14-052-Annex_IV_V_-_CIC_table.xls
# This can be parsed by saving as xlsx and then using:
#
# using XLSX
# wb = XLSX.readxlsx("EIOPA-14-052-Annex_IV_V_-_CIC_table.xlsx")
# ws = wb["Annex IV - Table"]
# firstdigit = Symbol.(vec(ws[7,3:18]))
# JSON.json("firstdigit.json",firstdigit)
# seconddigit = Symbol.(ws[8:25,3:18])
# JSON.json("seconddigit.json",seconddigit)

end # module CICs
