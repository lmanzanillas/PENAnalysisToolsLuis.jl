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
   inds = Int[]
   new_threshold = threshold
   if threshold != 0
      new_threshold = threshold
   else
      ground_level = mean(signal) 
      rms  = sqrt(sum(signal[:].^2.) / length(signal[:]))
      new_threshold = ground_level + 2*rms
   end
   
   if length(signal)>1
       if signal[1]>signal[2] && signal[1] > new_threshold
           push!(inds,1)
       end
       for i=2:length(signal)-1
           if signal[i-1]<signal[i]>signal[i+1] && signal[i] > new_threshold
               push!(inds,i)
           end
       end
       if signal[end]>signal[end-1]
           push!(inds,length(signal))
       end
   end
   inds
end


