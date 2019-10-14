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


export convert_struck_to_h5, convert_dset_to_h5, read_data_from_struck

include("HDF5Conversion.jl")
include("ReadStruck.jl")


end