# Customize 'which' option for ZSH
[ ${SHELL##*/} = 'zsh' ] && export GBT__WHICH_OPTS='-p'

[ -z "$GBT__SOURCE_COMPRESS" ] && GBT__SOURCE_COMPRESS='gzip -qc9'
[ -z "$GBT__SOURCE_DECOMPRESS" ] && GBT__SOURCE_DECOMPRESS='gzip -qd'
[ -z "$GBT__SOURCE_BASE64_DEC" ] && GBT__SOURCE_BASE64_DEC='-d'

function gbt__err() {
    echo "$@" >&2
}
