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


export convert_struck_to_h5, convert_struck_to_h5, convert_dset_to_h5, read_data_from_struck, take_struck_data, findLocalMaxima, getBaseline, peakIntegral, wfIntegral

include("HDF5Conversion.jl")
include("Struck/read_data_from_struck.jl")
include("Struck/create_struck_daq_file.jl")
include("Struck/take_struck_data.jl")
include("Algorithms/getBaseline.jl")
include("Algorithms/findLocalMaxima.jl")
include("Algorithms/peakIntegral.jl")
include("Algorithms/wfIntegral.jl")


end
