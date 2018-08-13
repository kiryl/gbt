declare -A GBT__PLUGINS_LOCAL__HASH
for P in $(echo ${GBT__PLUGINS_LOCAL:-docker,mysql,ssh,vagrant} | sed -r -e 's/(.[^,]+)(,\s*|$)/\L\1 /g'); do
    GBT__PLUGINS_LOCAL__HASH[$P]=1
done

declare -A GBT__PLUGINS_REMOTE__HASH
for P in $(echo ${GBT__PLUGINS_REMOTE:-docker,mysql,ssh,su,sudo,vagrant} | sed -r 's/(.[^,]+)(,\s*|$)/\L\1 /g'); do
    GBT__PLUGINS_REMOTE__HASH[$P]=1
done

declare -A GBT__CARS_REMOTE__HASH
for P in $(echo ${GBT__CARS_REMOTE:-dir,git,hostname,os,sign,status,time} | sed -r 's/(.[^,]+)(,\s*|$)/\L\1 /g'); do
    GBT__CARS_REMOTE__HASH[$P]=1
done


function gbt__local_rcfile() {
    local GBT__CONF="/tmp/.gbt.$RANDOM"
    echo -n '' > $GBT__CONF

    gbt__get_sources >> $GBT__CONF

    echo -e "#!/bin/bash\nbash --rcfile $GBT__CONF \"\$@\"" > $GBT__CONF.bash
    chmod +x $GBT__CONF.bash

    echo $GBT__CONF
}


function gbt__get_sources_cars() {
    local C=$1

    [ "$C" = 'exectime' ] && cat $GBT__HOME/sources/exec_time/bash
    [ "${C:0:6}" = 'custom' ] && C=${C:0:6}

    cat $GBT__HOME/sources/gbts/car/$C.sh
}


function gbt__get_sources() {
    [ -z "$GBT__HOME" ] && gbt__err "'GBT__HOME' not defined" && return 1

    [ -z "$GBT__SOURCE_MINIMIZE" ] && GBT__SOURCE_MINIMIZE="sed -r -e '/^(\\s*#.*|)\$/d' -e 's/^\\s+//g' -e 's/default([A-Z])/d\\1/g' -e 's/model-/m-/g' -e 's/\\s{2,}/\\x20/g'"

    # Conditional for remote only (GBT__PLUGINS_REMOTE)
    [ -n "${GBT__PLUGINS_REMOTE__HASH[ssh]}" ] && [ -z "$GBT__THEME_SSH" ] && local GBT__THEME_SSH="$GBT__HOME/sources/gbts/theme/ssh/${GBT__THEME_SSH_NAME:-default}.sh"
    [ -n "${GBT__PLUGINS_REMOTE__HASH[mysql]}" ] && [ -z "$GBT__THEME_MYSQL" ] && local GBT__THEME_MYSQL="$GBT__HOME/sources/gbts/theme/mysql/${GBT__THEME_MYSQL_NAME:-default}.sh"

    (
        echo "export GBT__CONF='$GBT__CONF'"
        cat $GBT__HOME/sources/gbts/{car,cmd{,/remote}}/_common.sh

        # Allow to override default list of cars defined in the theme
        [ -n "$GBT__THEME_REMOTE_CARS" ] && echo "export GBT__THEME_REMOTE_CARS='$GBT__THEME_REMOTE_CARS'"
        [ -n "$GBT__THEME_MYSQL_CARS" ] && echo "export GBT__THEME_MYSQL_CARS='$GBT__THEME_MYSQL_CARS'"

        if [[ $(ps -p $$ | awk '$1 != "PID" {print $(NF)}') == 'zsh' ]]; then
            for P in "${(@k)GBT__PLUGINS_REMOTE__HASH}"; do
                cat $GBT__HOME/sources/gbts/cmd/remote/$P.sh
            done

            for C in "${(@k)GBT__CARS_REMOTE__HASH}"; do
                gbt__get_sources_cars $C
            done
        else
            for P in "${!GBT__PLUGINS_REMOTE__HASH[@]}"; do
                cat $GBT__HOME/sources/gbts/cmd/remote/$P.sh
            done

            for C in "${!GBT__CARS_REMOTE__HASH[@]}"; do
                gbt__get_sources_cars $C
            done
        fi

        if [ -n "${GBT__PLUGINS_REMOTE__HASH[ssh]}" ]; then
            echo 'function gbt__ssh_theme() {'
            cat $GBT__THEME_SSH
            echo '}'
        fi

        if [ -n "${GBT__PLUGINS_REMOTE__HASH[mysql]}" ]; then
            echo 'function gbt__mysql_theme() {'
            cat $GBT__THEME_MYSQL
            echo '}'
        fi

        [ -n "${GBT__CARS_REMOTE__HASH[ssh]}" ] && [ -n "$GBT__THEME_SSH_CARS" ] && echo "export GBT__THEME_SSH_CARS='$GBT__THEME_SSH_CARS'"
        alias | awk '/gbt_/ {sub(/^(alias )?(gbt___)?/, "", $0); print "alias "$0}'
        echo "PS1='\$(GbtMain \$?)'"
    ) | eval "$GBT__SOURCE_MINIMIZE"
}
