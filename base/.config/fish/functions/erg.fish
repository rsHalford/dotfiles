function erg
    set result (fuzzy-file-line)
    if test -n "$result"
        "$EDITOR" (string split " " -- $result)
    end
end
