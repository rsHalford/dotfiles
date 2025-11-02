function is --description 'test if given file is of a file type. is TYPE FILE'
    set -l stats (file "$argv[2]")

    if string match -q "*$argv[1]*" $stats
        return 0
    else
        return 1
    end
end
