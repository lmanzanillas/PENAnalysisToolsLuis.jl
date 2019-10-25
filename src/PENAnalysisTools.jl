__precompile__(true)

module PENAnalysisTools

using Glob
using CompressedStreams
using SIS3316Digitizers
using HDF5
using DataFrames
using Dates
using ArraysOfArrays
using TypedTables
using ProgressMeter
using Statistics
using Pkg


export convert_struck_to_h5, convert_struck_to_h5, convert_dset_to_h5, read_data_from_struck, take_struck_data

include("HDF5Conversion.jl")
include("Struck/read_data_from_struck.jl")
include("Struck/create_struck_daq_file.jl")
include("Struck/take_struck_data.jl")
include("Algorithms/tools_pen_wf.jl")


end
