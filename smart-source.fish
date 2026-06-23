# smart-source v1 - by DavidBevi
# detect shebang and prompt user to follow it
function smart-source
    # help
    if contains -- "$argv[1]" -h --help
        echo -e "\nUSAGE:\n  smart-source \e[1m/path/to/file\e[0m"
        echo -e "  - if \e[1mfile\e[0m contains a \e[1mvalid shebang\e[0m you will be asked"
        echo -e "    if you want to follow the shebang or source it in fish"
        echo -e "  - else \e[1mfile\e[0m will be sourced in fish, just like if you used"
        echo -e "    '\e[1msource file\e[0m' or '\e[1m. file\e[0m'"
        echo -e "\nWARNING:\n  Some scripts won't work properly:\e[0m"
        echo -e "  - with '\e[1msource file\e[0m' the file is loaded in the current shell"
        echo -e "    and is able to interact with its context"
        echo -e "  - with (eg) '\e[1mbash file\e[0m' you create a sub-shell with a new"
        echo -e "    context, so this breaks files designed to be sourced\n"
        return 0
    end

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
                echo -e "\e[7m ▶ $bin \e[0m"
                eval $bin $argv
                echo -e "\e[7m ◼ $bin \e[0m"

            # n -> use fish
            else
                echo -e "ℹ️ Continuing execution in Fish\n"
                builtin source $argv
            end
        end
    end
end
