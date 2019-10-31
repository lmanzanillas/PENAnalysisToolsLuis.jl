"""
Find all the peaks above a certain threhsold in a waveform
takes as entry a waveform or an array of number and return an array with the position of the maximums in the array
...
#function to compute the integral of the peaks
#look at the bins +/- 10 around the peak and add all the bins 
# Arguments
- signal::Vector: Wavefor to be analyzed
- threshold: value given for the user to look for peaks above this value
...
"""


function peakIntegral(signal::Vector, peakPosition = 1)
    integral = 0
    #make sure the peak is completed asking to be at least 12 samples after the beggining or before the end
    if  12 < peakPosition < length(signal)-12
        for i = peakPosition-11 : peakPosition+11
            #if signal[i] > ground
                integral += signal[i]
            #end
        end
    end
    integral
end


