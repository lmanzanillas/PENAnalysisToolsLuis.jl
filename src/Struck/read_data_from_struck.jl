"""
        read_data_from_struck(filename:String; just_evt_t=false)

Reads one Struck (*.dat) file and returns a Named Table. Keys: samples, chid, evt_t, energy
...
# Arguments
- `filename::String`: Path to *.dat file as a string.
- `just_evt_t::Boolean=false`: If this is set to `true` the function will only return the timestamps.
...
"""
function read_data_from_struck(filename::String; just_evt_t=false)

    input = open(CompressedFile(filename))
    reader = eachchunk(input, SIS3316Digitizers.UnsortedEvents)
    if just_evt_t
        df = DataFrame(
          evt_t   = Float64[]
        )
    else
        df = DataFrame(
            evt_t   = Float64[],
            samples = Array{Int32,1}[],
            chid    = Int32[],
            energy  = []
        )
    end

    sorted = 0
    nchunks = 0
    
    for unsorted in reader
        nchunks += 1
        sorted = sortevents(unsorted)
        #return sorted
        for evt in eachindex(sorted)
	    #check if all channels have signals
	    if prod([i in collect(keys(sorted[evt])) for i in 1:6]) == 0; continue; end

	    #save information
            for ch in sort(collect(keys(sorted[evt])))#ch = collect(keys(sorted[evt]))[1]
            if just_evt_t
                push!(df, time(sorted[evt][ch]))
            else
                push!(df, (time(sorted[evt][ch]), sorted[evt][ch].samples, ch, sorted[evt][ch].energy))
            end
	    end

        end
        empty!(sorted)
    end
    close(input)
    if just_evt_t
        return (evt_t = df.evt_t)
    else
        return (evt_t = df.evt_t, samples = df.samples, chid = df.chid, energy = df.energy)
    end
end
