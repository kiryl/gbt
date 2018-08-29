# Create executable that is used as shell in 'su'
if [ ! -e "$GBT__CONF.bash" ]; then
    echo -e "#!/bin/bash\nexec -a gbt.bash bash --rcfile $GBT__CONF \"\$@\"" > $GBT__CONF.bash
    chmod +x $GBT__CONF.bash
fi

# Load remote custom profile if it exists
if [ -e ~/.gbt_profile ]; then
    source ~/.gbt_profile
fi
