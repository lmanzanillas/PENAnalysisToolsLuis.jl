__precompile__(true)

module PENAnalysisTools

using Glob
using CompressedStreams
using SIS3316Digitizers
using HDF5
using DataFrames
using ArraysOfArrays
using TypedTables
using ProgressMeter
using Pkg


export convert_struck_to_h5, convert_dset_to_h5, read_data_from_struck

include("HDF5Conversion.jl")
include("Struck/read_data_from_struck.jl")


end