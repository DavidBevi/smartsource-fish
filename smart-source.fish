# detect shebang and prompt user to follow it
function smart-source
    # if no shebang
    set firstline (head -n 1 -- $argv[1])
    if not string match -rq '^#!' -- $firstline
        builtin source $argv

    # if shebang
    else
        # extract the bin name
        set cmd (string trim -- (string replace -r '^#!\s*' '' -- $firstline))
        if string match -q '*/env' -- (string split ' ' -- $cmd)[1]
            set bin (string split ' ' -- $cmd)[2]
        else
            set bin (string split ' ' -- $cmd)[1]
        end

        # if invalid bin -> use fish
        if not command -sq $bin
            echo -e "ℹ️ Shebang '$firstline' cannot be validated\nℹ️ -> Continuing execution in Fish\n"
            builtin source $argv

        # if valid bin -> ask user
        else
            echo "ℹ️ Shebang '$firstline' detected"
            read -P "ℹ️ -> Leave fish shell and enter $bin shell? (y/n) " -n 1 answer

            # y -> fwd to bin
            if string match -iq 'y' -- $answer
                echo -en "ℹ️ Launching '$bin $argv'… "
                eval $bin $argv
                echo "finished"

            # n -> use fish
            else
                echo -e "ℹ️ Continuing execution in Fish\n"
                builtin source $argv
            end
        end
    end
end
