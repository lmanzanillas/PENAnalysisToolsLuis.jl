"""
        create_struck_daq_file(settings::NamedTuple)

Creates an individual `pmt_daq.scala` file
...
# Arguments
- `settings::NamedTuple`: NamedTuple containing all settings. See Example.
...
...
# Example settings
- `settings = (fadc = "gelab-fadc08", 
output_basename = "test-measurement", 
data_dir = "../data/",
conv_data_dir = "../conv_data/",
measurement_time = 20,
number_of_measurements = 5,
channels = [1,2,3,4,5,6],
trigger_threshold = [55],
trigger_pmt = [5,6],
peakTime = 2, 
gapTime = 2, 
nPreTrig = 192,
nSamples = 256,
saveEnergy = true
) `
...
"""
function create_struck_daq_file(settings::NamedTuple)
    new_daq = open(Pkg.dir("PENAnalysisTools")*"src/Struck/pmt_daq_6pmt_backup.scala", "r") do file
        temp = readlines(file)
        i = 1
        while i <= length(temp)
            if length(split(temp[i], "//Channels START")) > 1
                pmt_str = ""
                j = 1
                while j <= length(settings.channels)
                    temp[i+1] = "val pmt"*string(settings.channels[j])*" = Ch("*string(settings.channels[j])*")"
                    if j < length(settings.channels)
                        pmt_str = pmt_str*"pmt"*string(settings.channels[j])*", "
                    else 
                        pmt_str = pmt_str*"pmt"*string(settings.channels[j])
                    end
                    i += 1
                    j += 1
                end
                temp[i+1] = "val pmtChannels = Ch("*pmt_str*")"
            end

            if length(split(temp[i], "val adc = SIS3316")) > 1
                temp[i] = "val adc = SIS3316(\"vme-sis3316://"*settings.fadc*"\", \"adc\")"
            end

            if length(split(temp[i], "val outputBasename =")) > 1
                temp[i] = "val outputBasename = \""*settings.output_basename*"\""
            end

            if length(split(temp[i], "val measurementTime =")) > 1
                temp[i] = "val measurementTime = "*string(settings.measurement_time)
            end

            if length(split(temp[i], "// Threshold START")) > 1
                j = 1
                while j <= length(settings.trigger_pmt)
                    if length(settings.trigger_pmt) == length(settings.trigger_threshold)
                        temp[i+1] = "val threshold_"*string(settings.trigger_pmt[j])*" = "*string(settings.trigger_threshold[j])
                        temp[i+2] = "val trigger_pmt"*string(settings.trigger_pmt[j])*" = pmt"*string(settings.trigger_pmt[j])
                        temp[i+3] = "adc.trigger_threshold_set(trigger_pmt"*string(settings.trigger_pmt[j])*" --> threshold_"*string(settings.trigger_pmt[j])*")"
                    elseif length(settings.trigger_pmt) != length(settings.trigger_threshold) && length(settings.trigger_threshold) == 1
                        temp[i+1] = "val threshold_"*string(settings.trigger_pmt[j])*" = "*string(settings.trigger_threshold[1])
                        temp[i+2] = "val trigger_pmt"*string(settings.trigger_pmt[j])*" = pmt"*string(settings.trigger_pmt[j])
                        temp[i+3] = "adc.trigger_threshold_set(trigger_pmt"*string(settings.trigger_pmt[j])*" --> threshold_"*string(settings.trigger_pmt[j])*")"
                    else
                        return "Length of 'trigger_pmt' amd 'trigger_threshold' has to be equal or length of 'trigger_threshold has to be 1!'"
                    end
                    j += 1
                    i += 3
                end
            end

            if length(split(temp[i], "val peakTime =")) > 1
                temp[i] = "val peakTime = "*string(settings.peakTime)
            end
            if length(split(temp[i], "val gapTime  =")) > 1
                temp[i] = "val gapTime =  "*string(settings.gapTime)
            end
            if length(split(temp[i], "val nPreTrig =")) > 1
                temp[i] = "val nPreTrig = "*string(settings.nPreTrig)
            end
            if length(split(temp[i], "val nSamples =")) > 1
                temp[i] = "val nSamples = "*string(settings.nSamples)
            end
            if length(split(temp[i], "save_energy =")) > 1
                temp[i] = "      save_energy = "*string(settings.saveEnergy)*","
            end


            i += 1
        end
        return(temp)
    end
    open("pmt_daq.scala", "w") do file
        for ln in new_daq
            write(file, ln*"\n")
        end    
    end
end