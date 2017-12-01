#!/bin/ash
#copyright by monlor
source /etc/monlor/scripts/base.sh

logsh "【Tools】" "正在卸载工具箱..."

logsh "【Tools】" "停止所有插件"

cat $monlorpath/config/version.txt | grep -v monlor | cut -d, -f1 | while read line
do
	result=$(uci -q get monlor.$line.enable)
	[ "$result" == '1' ] && $monlorpath/apps/$line/script/$line.sh stop
done

logsh "【Tools】" "删除所有工具箱文件"

result=$(cat /etc/profile | grep monlor | wc -l)
if [ "$result" != 0 ]; then
	sed -i "s#:$monlorpath/scripts##" /etc/profile
fi

logsh "【Tools】" "删除定时任务"
result=$(cat /etc/crontabs/root | grep dayjob.sh | wc -l)
if [ "$result" != '0' ]; then
	sed -i "/dayjob.sh/d" /etc/crontabs/root
fi

result=$(cat /etc/crontabs/root | grep monitor.sh | wc -l)
if [ "$result" != '0' ]; then
	sed -i "/monitor.sh/d" /etc/crontabs/root
fi

result=$(cat /etc/firewall.user | grep init.sh | wc -l) > /dev/null 2>&1
if [ "$result" != '0' ]; then
	sed -i "/init.sh/d" /etc/firewall.user
fi

if [ -f "$monlorconf" ]; then
	mv $monlorconf $userdisk/monlor.conf
fi

xunlei_enable=$(uci get monlor.tools.xunlei)
if [ "$xunlei_enable" == '1' ]; then
	logsh "【Tools】" "检测到迅雷被关闭，正在恢复，重启后生效"
	[ ! -f /usr/sbin/xunlei.sh ] && mv /usr/sbin/xunlei.sh.bak /usr/sbin/xunlei.sh
fi

rm -rf /userdisk/data/.monlor.log > /dev/null 2>&1

if [ -f "/etc/config/monlor" ]; then
	rm -rf /etc/config/monlor
fi

logsh "【Tools】" "See You!"

rm -rf $monlorpath
