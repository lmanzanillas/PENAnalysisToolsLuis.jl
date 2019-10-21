"""
        convert_struck_to_h5(filename:String; conv_data_dir="../conv_data/")

Converts one Struck (*.dat) file to *.h5 format.
Structure in the *.h5 file will be:
- filename (group)
    - chid       : list of channel IDs
    - timestamps : timestamps for each event
    - samples    : samples for each event in one matrix
...
# Arguments
- `filename::String`: Path to *.dat file as a string.
- `conv_data_dir::String="../conv_data/"`: Path where the converted files should be stored as a string.
...
"""
function convert_struck_to_h5(filename::String; conv_data_dir="../conv_data/")
    if !isfile(filename)
        return "File does not exist: "*filename
    end

    if length(split(basename(filename), ".dat")) == 2
        real_filename = split(basename(filename), ".dat")[1]
    else 
        return "Wrong file format: "*filename
    end

    if isfile(conv_data_dir*real_filename*".h5")
        ans = getUserInput(String, "File exists. Do you want to overwrite? Y/n");
        if ans == "Y" || ans == "yes" || ans == "y" || ans == ""
            rm(conv_data_dir*real_filename*".h5");
        else 
            return "Please enter a different filename then."
        end
    end
    
    h5 = h5open(conv_data_dir*real_filename*".h5", "w") do file
        g    = g_create(file, "raw-data")
        dset = read_data_from_struck(filename)

        y = length(dset.samples);
        x = length(dset.samples[1]);

        A = Int.(zeros(y,x));

        i = 1
        while i <= y
            A[i, 1:x] = dset.samples[i]
            i += 1
        end

        g["timestamps", "chunk", 500] = dset.evt_t;   
        g["chid", "chunk", 500]       = dset.chid;
        g["samples", "chunk", (500,x), "shuffle", (), "deflate", 3]    = A;
    end
    return nothing
end



function getUserInput(T=String,msg="")
    print("$msg ")
    if T == String
        return readline()
    else
        try
            return parse(T,readline())
        catch
            println("Sorry, I could not interpret your answer. Please try again")
            getUserInput(T,msg)
        end
    end
end
  
"""
        convert_dset_to_h5(dset_glob_str::String, conv_filename::String; conv_data_dir="../conv_data/")

Converts several Struck (*.dat) file to one *.h5 format.
Structure in the *.h5 file will be:
- filename 1 (group)
    - chid       : list of channel IDs
    - timestamps : timestamps for each event
    - samples    : samples for each event in one matrix
- filename 2 (group)
    - chid       : list of channel IDs
    - timestamps : timestamps for each event
    - samples    : samples for each event in one matrix
- and so on
...
# Arguments
- `dset_glob_str::String`: Path to *.dat file as a Glob-string.
- `conv_filename::String`: Name of the output file.
- `conv_data_dir::String="../conv_data/"`: Path where the converted files should be stored as a string.
...
# Examples
```julia-repl
julia> convert_dset_to_h5("../data/*-1000V*.dat", "Output_Filename", conv_data_dir="../conv_data/")
```
"""
function convert_dset_to_h5(dset_glob_str::String, conv_filename::String; conv_data_dir="../conv_data/", delete = false)
    timestamp = string(now())
    conv_filename = conv_filename*timestamp
    if isfile(conv_data_dir*conv_filename*".h5")
        ans = getUserInput(String, "File exists. Do you want to overwrite? Y/n");
        if ans == "Y" || ans == "yes" || ans == "y" || ans == ""
            rm(conv_data_dir*conv_filename*".h5");
        else 
            return "Please enter a different filename then."
        end
    end
    
    files = glob(dset_glob_str)
    # Check files for *.dat format:
    break_fct = false
    for file in files
        if length(split(basename(file), ".dat")) != 2
            break_fct = true
            println("Wrong file format: "*file)
        end
    end
    
    if break_fct || length(files) == 0
        return "Please check your glob string!"
    end
    
    p = Progress(length(files), dt=0.5,
            barglyphs=BarGlyphs('|','█', ['▁' ,'▂' ,'▃' ,'▄' ,'▅' ,'▆', '▇'],' ','|',),
            barlen=10)
    
    filesize = 0
    @info "Files to process: "*string(length(files))
    
    x = 0 # to check for dimensions
    for file in files
        raw_data = read_data_from_struck(file);
        if x != length(raw_data.samples[1]) && x != 0
            return "Dimension missmatch: "*file
        end
        x = length(raw_data.samples[1]);
        y = length(raw_data.evt_t);
        evt_t = float.(zeros(y));
        chid  = Int.(zeros(y));
        samples = Int.(zeros(y, x));
        evt_t = raw_data.evt_t;
        chid  = raw_data.chid;
        i = 1
        while i <= length(raw_data.samples)
            samples[i, 1:x] = raw_data.samples[i];
            i += 1
        end
        
        real_filename = string(split(basename(file), ".dat")[1]);
        
        if isfile(conv_data_dir*conv_filename*".h5") 
            h5 = h5open(conv_data_dir*conv_filename*".h5", "r+") do f
                g = g_create(f, real_filename)
                g["timestamps", "chunk", 500] = evt_t;
                g["chid", "chunk", 500]       = chid;
                g["samples", "chunk", (500,x), "shuffle", (), "deflate", 3] = samples;
            end
        else
            h5 = h5open(conv_data_dir*conv_filename*".h5", "w") do f
                g = g_create(f, real_filename)
                g["timestamps", "chunk", 500] = evt_t;
                g["chid", "chunk", 500]       = chid;
                g["samples", "chunk", (500,x), "shuffle", (), "deflate", 3] = samples;
            end
        end
        filesize += (stat(file).size)/1e6
        next!(p)
    end 
    @info "Total filesize: "*string(round(filesize, digits=2))*" MB"
    @info "Compressed filesize: "*string(round(stat(conv_data_dir*conv_filename*".h5").size/1e6, digits=2))*" MB"
    #ans = getUserInput(String, "Do you want to delete the *.dat files? Y/n");
    if delete
        for file in files
            rm(file)
        end
    end
end
