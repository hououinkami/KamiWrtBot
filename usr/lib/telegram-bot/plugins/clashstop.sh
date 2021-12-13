uci -q set openclash.config.enable=0
sleep 1
uci -q commit openclash
sleep 1
/etc/init.d/openclash stop