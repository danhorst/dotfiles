#! /bin/bash

# NOTE:  Todo.sh requires the todo.cfg configuration file to run.
# Place the todo.cfg file in your home directory or use the -d option for a custom location.

[ -f VERSION-FILE ] && . VERSION-FILE || VERSION="2.4"
version() { sed -e 's/^    //' <<EndVersion
        TODO.TXT Command Line Interface v$VERSION
        
        First release: 5/11/2006
        Original conception by: Gina Trapani (http://ginatrapani.org)
        Contributors: http://github.com/ginatrapani/todo.txt-cli/network
        License: GPL, http://www.gnu.org/copyleft/gpl.html
        More information and mailing list at http://todotxt.com
        Code repository: http://github.com/ginatrapani/todo.txt-cli/tree/master
EndVersion
    exit 1
}

# Set script name early.
TODO_SH=$(basename "$0")
export TODO_SH

oneline_usage="$TODO_SH [-fhpantvV] [-d todo_config] action [task_number] [task_description]"

usage()
{
    sed -e 's/^    //' <<EndUsage
    Usage: $oneline_usage
    Try '$TODO_SH -h' for more information.
EndUsage
    exit 1
}

shorthelp()
{
    sed -e 's/^    //' <<EndHelp
      Usage: $oneline_usage

      Actions:
        add|a "THING I NEED TO DO +project @context"
        addto DEST "TEXT TO ADD"
        append|app NUMBER "TEXT TO APPEND"
        archive
        command [ACTIONS]
        del|rm NUMBER [TERM]
        dp|depri NUMBER
        do NUMBER
        help
        list|ls [TERM...]
        listall|lsa [TERM...]
        listcon|lsc
        listfile|lf SRC [TERM...]
        listpri|lsp [PRIORITY]
        listproj|lsprj
        move|mv NUMBER DEST [SRC]
        prepend|prep NUMBER "TEXT TO PREPEND"
        pri|p NUMBER PRIORITY
        replace NUMBER "UPDATED TODO"
        report

      See "help" for more details.
EndHelp
    exit 0
}

help()
{
    sed -e 's/^    //' <<EndHelp
      Usage: $oneline_usage

      Actions:
        add "THING I NEED TO DO +project @context"
        a "THING I NEED TO DO +project @context"
          Adds THING I NEED TO DO to your todo.txt file on its own line.
          Project and context notation optional.
          Quotes optional.

        addto DEST "TEXT TO ADD"
          Adds a line of text to any file located in the todo.txt directory.
          For example, addto inbox.txt "decide about vacation"

        append NUMBER "TEXT TO APPEND"
        app NUMBER "TEXT TO APPEND"
          Adds TEXT TO APPEND to the end of the todo on line NUMBER.
          Quotes optional.

        archive
          Moves done items from todo.txt to done.txt and removes blank lines.

        command [ACTIONS]
          Runs the remaining arguments using only todo.sh builtins.
          Will not call any .todo.actions.d scripts.

        del NUMBER [TERM]
        rm NUMBER [TERM]
          Deletes the item on line NUMBER in todo.txt.
          If term specified, deletes only the term from the line.

        depri NUMBER
        dp NUMBER
          Deprioritizes (removes the priority) from the item
          on line NUMBER in todo.txt.

        do NUMBER
          Marks item on line NUMBER as done in todo.txt.

        help
          Display this help message.

        list [TERM...]
        ls [TERM...]
          Displays all todo's that contain TERM(s) sorted by priority with line
          numbers.  If no TERM specified, lists entire todo.txt.

        listall [TERM...]
        lsa [TERM...]
          Displays all the lines in todo.txt AND done.txt that contain TERM(s)
          sorted by priority with line  numbers.  If no TERM specified, lists
          entire todo.txt AND done.txt concatenated and sorted.

        listcon
        lsc
          Lists all the task contexts that start with the @ sign in todo.txt.

        listfile SRC [TERM...]
        lf SRC [TERM...]
          Displays all the lines in SRC file located in the todo.txt directory,
          sorted by priority with line  numbers.  If TERM specified, lists
          all lines that contain TERM in SRC file.

        listpri [PRIORITY]
        lsp [PRIORITY]
          Displays all items prioritized PRIORITY.
          If no PRIORITY specified, lists all prioritized items.

        listproj
        lsprj
          Lists all the projects that start with the + sign in todo.txt.

        move NUMBER DEST [SRC]
        mv NUMBER DEST [SRC]
          Moves a line from source text file (SRC) to destination text file (DEST).
          Both source and destination file must be located in the directory defined
          in the configuration directory.  When SRC is not defined
          it's by default todo.txt.

        prepend NUMBER "TEXT TO PREPEND"
        prep NUMBER "TEXT TO PREPEND"
          Adds TEXT TO PREPEND to the beginning of the todo on line NUMBER.
          Quotes optional.

        pri NUMBER PRIORITY
        p NUMBER PRIORITY
          Adds PRIORITY to todo on line NUMBER.  If the item is already
          prioritized, replaces current priority with new PRIORITY.
          PRIORITY must be an uppercase letter between A and Z.

        replace NUMBER "UPDATED TODO"
          Replaces todo on line NUMBER with UPDATED TODO.

        report
          Adds the number of open todo's and closed done's to report.txt.



      Options:
        -@
            Hide context names in list output. Use twice to show context
            names (default).
        -+
            Hide project names in list output. Use twice to show project
            names (default).
        -d CONFIG_FILE
            Use a configuration file other than the default ~/todo.cfg
        -f
            Forces actions without confirmation or interactive input
        -h
            Display a short help message
        -p
            Plain mode turns off colors
        -P
            Hide priority labels in list output. Use twice to show
            priority labels (default).
        -a
            Don't auto-archive tasks automatically on completion
        -n
            Don't preserve line numbers; automatically remove blank lines
            on task deletion
        -t
            Prepend the current date to a task automatically
            when it's added.
        -v
            Verbose mode turns on confirmation messages
        -vv
            Extra verbose mode prints some debugging information
        -V
            Displays version, license and credits


      Environment variables:
        TODOTXT_AUTO_ARCHIVE=0          is same as option -a
        TODOTXT_CFG_FILE=CONFIG_FILE    is same as option -d CONFIG_FILE
        TODOTXT_FORCE=1                 is same as option -f
        TODOTXT_PRESERVE_LINE_NUMBERS=0 is same as option -n
        TODOTXT_PLAIN=1                 is same as option -p
        TODOTXT_DATE_ON_ADD=1           is same as option -t
        TODOTXT_VERBOSE=1               is same as option -v
        TODOTXT_DEFAULT_ACTION=""       run this when called with no arguments
        TODOTXT_SORT_COMMAND="sort ..." customize list output
        TODOTXT_FINAL_FILTER="sed ..."  customize list after color, P@+ hiding
EndHelp

    if [ -d "$TODO_ACTIONS_DIR" ]
    then
        echo ""
        for action in "$TODO_ACTIONS_DIR"/*
        do
            if [ -x "$action" ]
            then
                "$action" usage
            fi
        done
        echo ""
    fi


    exit 1
}

die()
{
    echo "$*"
    exit 1
}

cleanup()
{
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
    exit 0
}

archive()
{
    #defragment blank lines
    sed -i.bak -e '/./!d' "$TODO_FILE"
    [ $TODOTXT_VERBOSE -gt 0 ] && grep "^x " "$TODO_FILE"
    grep "^x " "$TODO_FILE" >> "$DONE_FILE"
    sed -i.bak '/^x /d' "$TODO_FILE"
    cp "$TODO_FILE" "$TMP_FILE"
    sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P' "$TMP_FILE" > "$TODO_FILE"
    #[[ $TODOTXT_VERBOSE -gt 0 ]] && echo "TODO: Duplicate tasks have been removed."
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: $TODO_FILE archived."
    cleanup
}


# == PROCESS OPTIONS ==
while getopts ":fhpnatvV+@Pd:" Option
do
  case $Option in
    '@' )
        ## HIDE_CONTEXT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_CONTEXT_NAMES++ ))
        if [ $(( $HIDE_CONTEXT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show context names
            unset HIDE_CONTEXTS_SUBSTITUTION
        else
            ## One or odd value -- hide context names
            export HIDE_CONTEXTS_SUBSTITUTION='[[:space:]]@[^[:space:]]\{1,\}'
        fi
        ;;
    '+' )
        ## HIDE_PROJECT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_PROJECT_NAMES++ ))
        if [ $(( $HIDE_PROJECT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show project names
            unset HIDE_PROJECTS_SUBSTITUTION
        else
            ## One or odd value -- hide project names
            export HIDE_PROJECTS_SUBSTITUTION='[[:space:]][+][^[:space:]]\{1,\}'
        fi
        ;;
    a )
        TODOTXT_AUTO_ARCHIVE=0
        ;;
    d )
        TODOTXT_CFG_FILE=$OPTARG
        ;;
    f )
        TODOTXT_FORCE=1
        ;;
    h )
        shorthelp
        ;;
    n )
        TODOTXT_PRESERVE_LINE_NUMBERS=0
        ;;
    p )
        TODOTXT_PLAIN=1
        ;;
    P )
        ## HIDE_PRIORITY_LABELS starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number hides project names and an odd number shows project
        ##   names.
        : $(( HIDE_PRIORITY_LABELS++ ))
        if [ $(( $HIDE_PRIORITY_LABELS % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show priority labels
            unset HIDE_PRIORITY_SUBSTITUTION
        else
            ## One or odd value -- hide priority labels
            export HIDE_PRIORITY_SUBSTITUTION="([A-Z])[[:space:]]"
        fi
        ;;
    t )
        TODOTXT_DATE_ON_ADD=1
        ;;
    v )
        : $(( TODOTXT_VERBOSE++ ))
        ;;
    V )
        version
        ;;
  esac
done
shift $(($OPTIND - 1))

# defaults if not yet defined
TODOTXT_VERBOSE=${TODOTXT_VERBOSE:-1}
TODOTXT_PLAIN=${TODOTXT_PLAIN:-0}
TODOTXT_CFG_FILE=${TODOTXT_CFG_FILE:-$HOME/todo.cfg}
TODOTXT_FORCE=${TODOTXT_FORCE:-0}
TODOTXT_PRESERVE_LINE_NUMBERS=${TODOTXT_PRESERVE_LINE_NUMBERS:-1}
TODOTXT_AUTO_ARCHIVE=${TODOTXT_AUTO_ARCHIVE:-1}
TODOTXT_DATE_ON_ADD=${TODOTXT_DATE_ON_ADD:-0}
TODOTXT_DEFAULT_ACTION=${TODOTXT_DEFAULT_ACTION:-}
TODOTXT_SORT_COMMAND=${TODOTXT_SORT_COMMAND:-env LC_COLLATE=C sort -f -k2}
TODOTXT_FINAL_FILTER=${TODOTXT_FINAL_FILTER:-cat}

# Export all TODOTXT_* variables
export ${!TODOTXT_@}

# Default color map
export NONE=''
export BLACK='\\033[0;30m'
export RED='\\033[0;31m'
export GREEN='\\033[0;32m'
export BROWN='\\033[0;33m'
export BLUE='\\033[0;34m'
export PURPLE='\\033[0;35m'
export CYAN='\\033[0;36m'
export LIGHT_GREY='\\033[0;37m'
export DARK_GREY='\\033[1;30m'
export LIGHT_RED='\\033[1;31m'
export LIGHT_GREEN='\\033[1;32m'
export YELLOW='\\033[1;33m'
export LIGHT_BLUE='\\033[1;34m'
export LIGHT_PURPLE='\\033[1;35m'
export LIGHT_CYAN='\\033[1;36m'
export WHITE='\\033[1;37m'
export DEFAULT='\\033[0m'

# Default priority->color map.
export PRI_A=$YELLOW        # color for A priority
export PRI_B=$GREEN         # color for B priority
export PRI_C=$LIGHT_BLUE    # color for C priority
export PRI_X=$WHITE         # color for rest of them

[ -e "$TODOTXT_CFG_FILE" ] || {
    CFG_FILE_ALT="$HOME/.todo.cfg"

    if [ -e "$CFG_FILE_ALT" ]
    then
        TODOTXT_CFG_FILE="$CFG_FILE_ALT"
    fi
}

if [ -z "$TODO_ACTIONS_DIR" -o ! -d "$TODO_ACTIONS_DIR" ]
then
    TODO_ACTIONS_DIR="$HOME/.todo.actions.d"
    export TODO_ACTIONS_DIR
fi

# === SANITY CHECKS (thanks Karl!) ===
[ -r "$TODOTXT_CFG_FILE" ] || die "Fatal error: Cannot read configuration file $TODOTXT_CFG_FILE"

. "$TODOTXT_CFG_FILE"

ACTION=${1:-$TODOTXT_DEFAULT_ACTION}

[ -z "$ACTION" ]    && usage
[ -d "$TODO_DIR" ]  || die "Fatal Error: $TODO_DIR is not a directory"
( cd "$TODO_DIR" )  || die "Fatal Error: Unable to cd to $TODO_DIR"

[ -w "$TMP_FILE"  ] || echo -n > "$TMP_FILE" || die "Fatal Error: Unable to write to $TMP_FILE"
[ -f "$TODO_FILE" ] || cp /dev/null "$TODO_FILE"
[ -f "$DONE_FILE" ] || cp /dev/null "$DONE_FILE"
[ -f "$REPORT_FILE" ] || cp /dev/null "$REPORT_FILE"

if [ $TODOTXT_PLAIN = 1 ]; then
    PRI_A=$NONE
    PRI_B=$NONE
    PRI_C=$NONE
    PRI_X=$NONE
    DEFAULT=$NONE
fi

# === HEAVY LIFTING ===
shopt -s extglob

_list() {
    local FILE="$1"
    ## If the file starts with a "/" use absolute path. Otherwise,
    ## try to find it in either $TODO_DIR or using a relative path
    if [ "${1:0:1}" == / ]
    then
        ## Absolute path
        src="$FILE"
    elif [ -f "$TODO_DIR/$FILE" ]
    then
        ## Path relative to todo.sh directory
        src="$TODO_DIR/$1"
    elif [ -f "$FILE" ]
    then
        ## Path relative to current working directory
        src="$FILE"
    else
        echo "TODO: File $FILE does not exist."
        exit 1
    fi

    ## Get our search arguments, if any
    shift ## was file name, new $1 is first search term

    ## Prefix the filter_command with the pre_filter_command
    filter_command="${pre_filter_command:-}"

    for search_term in "$@"
    do
        ## See if the first character of $search_term is a dash
        if [ ${search_term:0:1} != '-' ]
        then
            ## First character isn't a dash: hide lines that don't match
            ## this $search_term
            filter_command="${filter_command:-} ${filter_command:+|} \
                grep -i \"$search_term\" "
        else
            ## First character is a dash: hide lines that match this
            ## $search_term
            #
            ## Remove the first character (-) before adding to our filter command
            filter_command="${filter_command:-} ${filter_command:+|} \
                grep -v -i \"${search_term:1}\" "
        fi
    done

    ## If post_filter_command is set, append it to the filter_command
    [ -n "$post_filter_command" ] && {
        filter_command="${filter_command:-}${filter_command:+ | }${post_filter_command:-}"
    }

    ## Figure out how much padding we need to use
    ## We need one level of padding for each power of 10 $LINES uses
    LINES=$( sed -n '$ =' "$src" )
    PADDING=${#LINES}

    ## Number the file, then run the filter command,
    ## then sort and mangle output some more
    items=$(
        sed = "$src"                                            \
        | sed "N; s/^/     /; s/ *\(.\{$PADDING,\}\)\n/\1 /"    \
        | grep -v "^[0-9]\+ *$"
    )
    if [ "${filter_command}" ]; then
        filtered_items=$(echo -ne "$items" | eval ${filter_command})
    else
        filtered_items=$items
    fi
    filtered_items=$(
        echo -ne "$filtered_items"                              \
        | sed '''
            s/^     /00000/;
            s/^    /0000/;
            s/^   /000/;
            s/^  /00/;
            s/^ /0/;
          ''' \
        | eval ${TODOTXT_SORT_COMMAND}                                        \
        | sed '''
            /^[0-9]\{'$PADDING'\} x /! {
                s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g;
                s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g;
                s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g;
                s/\(.*([D-Z]).*\)/'$PRI_X'\1'$DEFAULT'/g;
            }
          '''                                                   \
        | sed '''
            s/'${HIDE_PRIORITY_SUBSTITUTION:-^}'//g
            s/'${HIDE_PROJECTS_SUBSTITUTION:-^}'//g
            s/'${HIDE_CONTEXTS_SUBSTITUTION:-^}'//g
          '''                                                   \
        | eval ${TODOTXT_FINAL_FILTER}                          \
    )
    echo -ne "$filtered_items${filtered_items:+\n}"

    if [ $TODOTXT_VERBOSE -gt 0 ]; then
        NUMTASKS=$( echo -ne "$filtered_items" | sed -n '$ =' )
        TOTALTASKS=$( echo -ne "$items" | sed -n '$ =' )

        echo "--"
        echo "TODO: ${NUMTASKS:-0} of ${TOTALTASKS:-0} tasks shown from $FILE"
    fi
    if [ $TODOTXT_VERBOSE -gt 1 ]
    then
        echo "TODO DEBUG: Filter Command was: ${filter_command:-cat}"
    fi
}

export -f _list

# == HANDLE ACTION ==
action=$( printf "%s\n" "$ACTION" | tr 'A-Z' 'a-z' )

## If the first argument is "command", run the rest of the arguments
## using todo.sh builtins.
## Else, run a actions script with the name of the command if it exists
## or fallback to using a builtin
if [ "$action" == command ]
then
    ## Get rid of "command" from arguments list
    shift
    ## Reset action to new first argument
    action=$( printf "%s\n" "$1" | tr 'A-Z' 'a-z' )
elif [ -d "$TODO_ACTIONS_DIR" -a -x "$TODO_ACTIONS_DIR/$action" ]
then
    "$TODO_ACTIONS_DIR/$action" "$@"
    cleanup
fi

## Only run if $action isn't found in .todo.actions.d
case $action in
"add" | "a")
    if [[ -z "$2" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Add: "
        read input
    else
        [ -z "$2" ] && die "usage: $TODO_SH add \"TODO ITEM\""
        shift
        input=$*
    fi

    if [[ $TODOTXT_DATE_ON_ADD = 1 ]]; then
        now=`date '+%Y-%m-%d'`
        input="$now $input"
    fi
    echo "$input" >> "$TODO_FILE"
    TASKNUM=$(sed -n '$ =' "$TODO_FILE")
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: '$input' added on line $TASKNUM."
    cleanup;;

"addto" )
    [ -z "$2" ] && die "usage: $TODO_SH addto DEST \"TODO ITEM\""
    dest="$TODO_DIR/$2"
    [ -z "$3" ] && die "usage: $TODO_SH addto DEST \"TODO ITEM\""
    shift
    shift
    input=$*

    if [ -f "$dest" ]; then
        echo "$input" >> "$dest"
        TASKNUM=$(sed -n '$ =' "$dest")
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: '$input' added to $dest on line $TASKNUM."
    else
        echo "TODO: Destination file $dest does not exist."
    fi
    cleanup;;

"append" | "app" )
    errmsg="usage: $TODO_SH append ITEM# \"TEXT TO APPEND\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"
    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item: No such todo."
    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Append: "
        read input
    else
        input=$*
    fi
    if sed -i.bak $item" s|^.*|& $input|" "$TODO_FILE"; then
        newtodo=$(sed "$item!d" "$TODO_FILE")
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "$item: $newtodo"
    else
        echo "TODO: Error appending task $item."
    fi
    cleanup;;

"archive" )
    archive;;

"del" | "rm" )
    # replace deleted line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $TODO_SH del ITEM#"
    item=$2
    [ -z "$item" ] && die "$errmsg"

    if [ -z "$3" ]; then

        [[ "$item" = +([0-9]) ]] || die "$errmsg"
        if sed -ne "$item p" "$TODO_FILE" | grep "^."; then
            DELETEME=$(sed "$item!d" "$TODO_FILE")

            if  [ $TODOTXT_FORCE = 0 ]; then
                echo "Delete '$DELETEME'?  (y/n)"
                read ANSWER
            else
                ANSWER="y"
            fi
            if [ "$ANSWER" = "y" ]; then
                if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
                    # delete line (changes line numbers)
                    sed -i.bak -e $item"s/^.*//" -e '/./!d' "$TODO_FILE"
                else
                    # leave blank line behind (preserves line numbers)
                    sed -i.bak -e $item"s/^.*//" "$TODO_FILE"
                fi
                [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: '$DELETEME' deleted."
                cleanup
            else
                echo "TODO: No tasks were deleted."
            fi
        else
            echo "$item: No such todo."
        fi
    else
        sed -i.bak -e $item"s/$3/ /g"  "$TODO_FILE"
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: $3 removed from $item."
    fi ;;

"depri" | "dp" )
    item=$2
    errmsg="usage: $TODO_SH depri ITEM#"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item: No such todo."
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    sed -e $item"s/^(.) //" "$TODO_FILE" > /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        #it's all good, continue
        sed -i.bak -e $item"s/^(.) //" "$TODO_FILE"
        NEWTODO=$(sed "$item!d" "$TODO_FILE")
        [ $TODOTXT_VERBOSE -gt 0 ] && echo -e "`echo "$item: $NEWTODO"`"
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: $item deprioritized."
        cleanup
    else
        die "$errmsg"
    fi;;

"do" )
    errmsg="usage: $TODO_SH do ITEM#"
    item=$2
    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item: No such todo."

    now=`date '+%Y-%m-%d'`
    # remove priority once item is done
    sed -i.bak $item"s/^(.) //" "$TODO_FILE"
    sed -i.bak $item"s|^|&x $now |" "$TODO_FILE"
    newtodo=$(sed "$item!d" "$TODO_FILE")
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "$item: $newtodo"
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: $item marked as done."

    if [ $TODOTXT_AUTO_ARCHIVE = 1 ]; then
        archive
    fi
    cleanup ;;

"help" )
    help
    ;;

"list" | "ls" )
    shift  ## Was ls; new $1 is first search term
    _list "$TODO_FILE" "$@"

    cleanup
    ;;

"listall" | "lsa" )
    shift  ## Was lsa; new $1 is first search term

    cat "$TODO_FILE" "$DONE_FILE" > "$TMP_FILE"
    _list "$TMP_FILE" "$@"

    cleanup
    ;;

"listfile" | "lf" )
    shift  ## Was listfile, next $1 is file name
    FILE="$1"
    shift  ## Was filename; next $1 is first search term

    _list "$FILE" "$@"

    cleanup
    ;;

"listcon" | "lsc" )
    grep -o '[^ ]*@[^ ]\+' "$TODO_FILE" | grep '^@' | sort -u
    cleanup ;;

"listproj" | "lsprj" )
    grep -o '[^ ]*+[^ ]\+' "$TODO_FILE" | grep '^+' | sort -u
    cleanup ;;


"listpri" | "lsp" )
    shift ## was "listpri", new $1 is priority to list

    if [ "${1:-}" ]
    then
        ## A priority was specified
        pri=$( printf "%s\n" "$1" | tr 'a-z' 'A-Z' | grep '^[A-Z]$' ) || {
            die "usage: $TODO_SH listpri PRIORITY
            note: PRIORITY must a single letter from A to Z."
        }
    else
        ## No priority specified; show all priority tasks
        pri="[[:upper:]]"
    fi
    pri="($pri)"

    _list "$TODO_FILE" "$pri"
    ;;

"move" | "mv" )
    # replace moved line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $TODO_SH mv ITEM# DEST [SRC]"
    item=$2
    dest="$TODO_DIR/$3"
    src="$TODO_DIR/$4"

    [ -z "$item" ] && die "$errmsg"
    [ -z "$4" ] && src="$TODO_FILE"
    [ -z "$dest" ] && die "$errmsg"

    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            if sed -ne "$item p" "$src" | grep "^."; then
                MOVEME=$(sed "$item!d" "$src")
                if  [ $TODOTXT_FORCE = 0 ]; then
                    echo "Move '$MOVEME' from $src to $dest? (y/n)"
                    read ANSWER
                else
                    ANSWER="y"
                fi
                if [ "$ANSWER" = "y" ]; then
                    if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
                        # delete line (changes line numbers)
                        sed -i.bak -e $item"s/^.*//" -e '/./!d' "$src"
                    else
                        # leave blank line behind (preserves line numbers)
                       sed -i.bak -e $item"s/^.*//" "$src"
                    fi
                    echo "$MOVEME" >> "$dest"

                    [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: '$MOVEME' moved from '$src' to '$dest'."
                    cleanup
                else
                    echo "TODO: No tasks moved."
                fi
            else
                echo "$item: No such item in $src."
            fi
        else
            echo "TODO: Destination file $dest does not exist."
        fi
    else
        echo "TODO: Source file $src does not exist."
    fi
    cleanup;;

"prepend" | "prep" )
    errmsg="usage: $TODO_SH prepend ITEM# \"TEXT TO PREPEND\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item: No such todo."

    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Prepend: "
        read input
    else
        input=$*
    fi

    if sed -i.bak $item" s|^.*|$input &|" "$TODO_FILE"; then
        newtodo=$(sed "$item!d" "$TODO_FILE")
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "$item: $newtodo"
    else
        echo "TODO: Error prepending task $item."
    fi
    cleanup;;

"pri" | "p" )
    item=$2
    newpri=$( printf "%s\n" "$3" | tr 'a-z' 'A-Z' )

    errmsg="usage: $TODO_SH pri ITEM# PRIORITY
note: PRIORITY must be anywhere from A to Z."

    [ "$#" -ne 3 ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"
    [[ "$newpri" = @([A-Z]) ]] || die "$errmsg"

    sed -e $item"s/^(.) //" -e $item"s/^/($newpri) /" "$TODO_FILE" > /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        #it's all good, continue
        sed -i.bak -e $item"s/^(.) //" -e $item"s/^/($newpri) /" "$TODO_FILE"
        NEWTODO=$(sed "$item!d" "$TODO_FILE")
        [ $TODOTXT_VERBOSE -gt 0 ] && echo -e "`echo "$item: $NEWTODO"`"
        [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: $item prioritized ($newpri)."
        cleanup
    else
        die "$errmsg"
    fi;;

"replace" )
    errmsg="usage: $TODO_SH replace ITEM# \"UPDATED ITEM\""
    shift; item=$1; shift

    [ -z "$item" ] && die "$errmsg"
    [[ "$item" = +([0-9]) ]] || die "$errmsg"

    todo=$(sed "$item!d" "$TODO_FILE")
    [ -z "$todo" ] && die "$item: No such todo."

    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        echo -n "Replacement: "
        read input
    else
        input=$*
    fi

    sed -i.bak $item" s|^.*|$input|" "$TODO_FILE"
    [ $TODOTXT_VERBOSE -gt 0 ] && NEWTODO=$(head -$item "$TODO_FILE" | tail -1)
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "$item: $todo"
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "replaced with"
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "$item: $NEWTODO"
    cleanup;;

"report" )
    #archive first
    sed '/^x /!d' "$TODO_FILE" >> "$DONE_FILE"
    sed -i.bak '/^x /d' "$TODO_FILE"

    NUMLINES=$( sed -n '$ =' "$TODO_FILE" )
    if [ ${NUMLINES:-0} = "0" ]; then
         echo "datetime todos dones" >> "$REPORT_FILE"
    fi
    #now report
    TOTAL=$( sed -n '$ =' "$TODO_FILE" )
    TDONE=$( sed -n '$ =' "$DONE_FILE" )
    TECHO=$(echo $(date +%Y-%m-%d-%T); echo ' '; echo ${TOTAL:-0}; echo ' ';
    echo ${TDONE:-0})
    echo $TECHO >> "$REPORT_FILE"
    [ $TODOTXT_VERBOSE -gt 0 ] && echo "TODO: Report file updated."
    cat "$REPORT_FILE"
    cleanup;;

* )
    usage
    ;;
esac
