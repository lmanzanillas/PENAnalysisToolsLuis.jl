"""
Find all the peaks above a certain threhsold in a waveform
takes as entry a waveform or an array of number and return an array with the position of the maximums in the array
...
# Arguments
- signal::Vector: Wavefor to be analyzed
- threshold: value given for the user to look for peaks above this value
...
"""

function findlocalmaxima(signal::Vector, threshold = 0 )
   #check if threshold value is given
   if threshold != 0
      threshold = threshold
   else
      ground_level = mean(signal) 
      rms  = sqrt(sum(signal[:].^2.) / length(signal[:]))
      threshold = ground_level + 2*rms
   end
   
   inds = Int[]
   if length(signal)>1
       if signal[1]>signal[2] && signal[1] > threshold
           push!(inds,1)
       end
       for i=2:length(signal)-1
           if signal[i-1]<signal[i]>signal[i+1] && signal[i] > threshold
               push!(inds,i)
           end
       end
       if signal[end]>signal[end-1]
           push!(inds,length(signal))
       end
   end
   inds
 end


#function to compute the integral of the peaks
#look at the bins +/- 10 around the peak and add all the bins 
function peak_integral(signal::Vector, peak_position = 100)
    integral = 0
    #make sure the peak is completed
    if  12 < peak_position < length(signal)-12
        for i = peak_position-11 : peak_position+11
            #if signal[i] > ground
                integral += signal[i]
            #end
        end
    end
    integral
end

#function integral of all the waveform
function wf_integral(signal::Vector)
    integral = 0
    nSamples = size(signal)[1]
    for i = 1 : nSamples
        integral += signal[i]
    end
    integral
end

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

