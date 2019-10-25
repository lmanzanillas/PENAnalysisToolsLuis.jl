"""
Find all the peaks above a certain threhsold in a waveform
takes as entry a waveform or an array of number and return an array with the position of the maximums in the array
...
# Arguments
- signal::Vector: Wavefor to be analyzed
- threshold: value given for the user to look for peaks above this value
...
"""


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


