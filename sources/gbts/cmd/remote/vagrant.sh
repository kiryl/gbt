function gbt_vagrant() {
    local VAGRANT_BIN=$(gbt__which vagrant)
    [ -z "$VAGRANT_BIN" ] && return 1

    gbt__check_md5

    if [ "$1" != 'ssh' ]; then
        $VAGRANT_BIN "$@"
    else
        shift

        $VAGRANT_BIN ssh --command "cat /etc/motd 2>/dev/null;
echo \"$(cat $GBT__CONF | eval "$GBT__SOURCE_COMPRESS" | $GBT__SOURCE_BASE64 | tr -d '\r\n')\" | $GBT__SOURCE_BASE64 $GBT__SOURCE_BASE64_DEC | $GBT__SOURCE_DECOMPRESS > $GBT__CONF &&
exec -a gbt.bash bash --rcfile $GBT__CONF" "$@"
    fi
}
