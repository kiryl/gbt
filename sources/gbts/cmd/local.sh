source $GBT__HOME/sources/gbts/cmd/_common.sh
source $GBT__HOME/sources/gbts/cmd/local/_common.sh

if [ -n "${GBT__PLUGINS_LOCAL__HASH[docker]}" ]; then
    source $GBT__HOME/sources/gbts/cmd/local/docker.sh
fi
if [ ${GBT__PLUGINS_LOCAL__HASH[mysql]+1} ]; then
    source $GBT__HOME/sources/gbts/cmd/local/mysql.sh
fi
if [ ${GBT__PLUGINS_LOCAL__HASH[ssh]+1} ]; then
    source $GBT__HOME/sources/gbts/cmd/local/ssh.sh
fi
if [ ${GBT__PLUGINS_LOCAL__HASH[su]+1} ]; then
    source $GBT__HOME/sources/gbts/cmd/local/su.sh
fi
if [ ${GBT__PLUGINS_LOCAL__HASH[sudo]+1} ]; then
    source $GBT__HOME/sources/gbts/cmd/local/sudo.sh
fi
if [ ${GBT__PLUGINS_LOCAL__HASH[vagrant]+1} ]; then
    source $GBT__HOME/sources/gbts/cmd/local/vagrant.sh
fi
