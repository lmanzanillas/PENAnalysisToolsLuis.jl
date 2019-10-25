"""
Find all the peaks above a certain threhsold in a waveform
takes as entry a waveform or an array of number and return an array with the position of the maximums in the array
...
# Arguments
- signal::Vector: Wavefor to be analyzed
- threshold: value given for the user to look for peaks above this value
...
"""



#function integral of all the waveform
function wf_integral(signal::Vector)
    integral = 0
    nSamples = size(signal)[1]
    for i = 1 : nSamples
        integral += signal[i]
    end
    integral
end


