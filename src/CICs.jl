module CICs

using Countries
using JSON

# Handles Complementary Identification Codes (CICs)

export CIC, category, subcategory, country

struct CIC
    cic::AbstractString
end

category(cic::CIC) = firstdigit[parse(Int, cic.cic[3], base=16)]
subcategory(cic::CIC) = seconddigit[parse(Int, cic.cic[4]),parse(Int, cic.cic[3], base=16)]
country(cic::CIC) = country(cic.cic[1:2])

function __init__()
    module_dir = @__DIR__
    global firstdigit = JSON.parsefile(joinpath(module_dir,"..", "data", "firstdigit.json"))
    global seconddigit = reshape(JSON.parsefile(joinpath(module_dir,"..", "data", "seconddigit.json")),(9,16))
end

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
