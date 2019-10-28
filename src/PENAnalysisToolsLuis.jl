__precompile__(true)

module PENAnalysisToolsLuis

using Glob
using CompressedStreams
using SIS3316Digitizers
using HDF5
using DataFrames
using Dates
using ArraysOfArrays
using TypedTables
using ProgressMeter
using Pkg
using Statistics


export convert_struck_to_h5, convert_struck_to_h5, convert_dset_to_h5, read_data_from_struck, take_struck_data findlocalmaxima getbaseline peak_integral

include("HDF5Conversion.jl")
include("Struck/read_data_from_struck.jl")
include("Struck/create_struck_daq_file.jl")
include("Struck/take_struck_data.jl")
include("Algorithms/getbaseline.jl")
include("Algorithms/peak_integral.jl")
#include("Algorithms/findlocalmaxima.jl")


end
