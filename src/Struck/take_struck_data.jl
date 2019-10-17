function edit_pmt_daq(fadc_name, channel_nr; nsamples=512)
    new_daq = open("/pmt_daq_backup.scala", "r") do file
        temp = readlines(file)
        i = 1
        while i <= length(temp)
            if length(split(temp[i], "val pmt1 = Ch(")) > 1
                temp[i] = "val pmt1 = Ch("*string(channel_nr)*")"
            elseif length(split(temp[i], "val adc = SIS3316(\"vme-sis3316://")) > 1
                temp[i] = "val adc = SIS3316(\"vme-sis3316://"*fadc_name*"\", \"adc\")"
            elseif length(split(temp[i], "val nSamples =  ")) > 1
                temp[i] = "  val nSamples =  "*string(nsamples)
            end
            i +=1
        end
        return(temp)
    end
    open("pmt_daq.scala", "w") do file
        for ln in new_daq
            write(file, ln*"\n")
        end    
    end
end