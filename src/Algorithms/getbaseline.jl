"""
Find all the peaks above a certain threhsold in a waveform
takes as entry a waveform or an array of number and return an array with the position of the maximums in the array
...
# Arguments
- signal::Vector: Wavefor to be analyzed
- threshold: value given for the user to look for peaks above this value
...
"""

#function to compute the baselines of a given wf, it takes a wf and compute the average
#removing +/- 5 samples around the peaks to avoid bias
function getbaseline(signal::Vector)
    Baseline = copy(signal)
    peaks_threshold = mean(Baseline) + 25.0 # only peaks with amplitudes larger than the average of 25 
    peak_pos = findlocalmaxima(Baseline,peaks_threshold)
    #peak_pos = findall(x -> x > peaks_threshold, signal)
    index_to_delete = []
    for i in peak_pos
        if length(index_to_delete) > 0 && index_to_delete[end] > i-6 #security check for two close peaks
            continue
        end
        if i < 10
            append!(index_to_delete,collect(1:i+5))
        elseif 10 < i < length(signal)-10 
            append!(index_to_delete,collect(i-5:i+5))
        else
            append!(index_to_delete,collect(i:length(signal)))
        end
    end
    deleteat!(Baseline,index_to_delete)
    baseline = mean(Baseline)
end

