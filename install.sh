#!/data/data/com.termux/files/usr/bin/bash
directory="debian-bullseye"
distribution="Debian Bullseye"
if [ -d "${PREFIX}/share/${directory}" ]; then
printf "\n\e[31mError: distribution ${distribution} is already installed.\n\n\e[0m"
exit
fi
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Checking device architecture...\n\e[0m"
case $(uname -m) in
aarch64) arch="arm64v8" multiarch="aarch64-linux-gnu" ;;
armv7l|armv8l) arch="arm32v7" multiarch="arm-linux-gnueabihf" ;;
i686) arch="i386" multiarch="i386-linux-gnu" ;;
x86_64) arch="amd64" multiarch="x86_64-linux-gnu" ;;
*)
printf "\e[34m[\e[32m*\e[34m]\e[31m Unsupported architecture.\n\n\e[0m"; exit ;;
esac
apt update > /dev/null 2>&1
apt install -y proot > /dev/null 2>&1
tarball="rootfs.tar.xz"
printf "\e[34m[\e[32m*\e[34m]\e[36m Downloading ${distribution}, please wait...\n\n\e[34m"
if ! curl --location --output "${tarball}" \
"https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/dist-${arch}/bullseye/rootfs.tar.xz"; then
printf "\n\e[34m[\e[32m*\e[34m]\e[31m Download failed, please check your network connection.\n\n\e[0m"
rm -f "${tarball}"
exit
fi
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Installing ${distribution}, please wait...\n\e[0m"
mkdir -p "${PREFIX}/share/${directory}"
proot --link2symlink tar -xf "${tarball}" --directory="${PREFIX}/share/${directory}" --exclude='dev'||:
rm -f "${tarball}"
printf "\e[34m[\e[32m*\e[34m]\e[36m Setting up ${distribution}, please wait...\n\e[0m"
cat <<- EOF > "${PREFIX}/share/${directory}/etc/ld.so.preload"
/lib/${multiarch}/libgcc_s.so.1
EOF
cat <<- EOF >> "${PREFIX}/share/${directory}/etc/profile"
export PULSE_SERVER="127.0.0.1"
export MOZ_FAKE_NO_SANDBOX="1"
export LANG="C.UTF-8"
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/etc/resolv.conf"
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/etc/hosts"
127.0.0.1 localhost
::1       ip6-localhost ip6-loopback
EOF
while read group_name group_id; do
cat <<- EOF >> "${PREFIX}/share/${directory}/etc/group"
${group_name}:x:${group_id}:
EOF
cat <<- EOF >> "${PREFIX}/share/${directory}/etc/gshadow"
${group_name}:!::
EOF
done < <(paste <(id -Gn | tr ' ' '\n') <(id -G | tr ' ' '\n'))
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.loadavg"
0.35 0.22 0.15 1/573 7767
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.stat"
cpu  265542 13183 24203 611072 152293 68 191340 255 0 0 0
cpu0 265542 13183 24203 611072 152293 68 191340 255 0 0 0
intr 815181 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ctxt 906205
btime 163178502
processes 25384
procs_running 1
procs_blocked 0
softirq 1857962 55 2536781 34 1723322 8 2457784 5 1914410
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.uptime"
11965.80 11411.22
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.vmstat"
nr_free_pages 705489
nr_alloc_batch 0
nr_inactive_anon 1809
nr_active_anon 61283
nr_inactive_file 69543
nr_active_file 58416
nr_unevictable 64
nr_mlock 64
nr_anon_pages 60894
nr_mapped 99503
nr_file_pages 130218
nr_dirty 9
nr_writeback 0
nr_slab_reclaimable 2283
nr_slab_unreclaimable 3714
nr_page_table_pages 1911
nr_kernel_stack 687
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 0
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 2262
nr_dirtied 3675
nr_written 3665
nr_pages_scanned 0
workingset_refault 1183
workingset_activate 1183
workingset_nodereclaim 0
nr_anon_transparent_hugepages 0
nr_free_cma 0
nr_dirty_threshold 21574
nr_dirty_background_threshold 5393
pgpgin 541367
pgpgout 23248
pswpin 1927
pswpout 2562
pgalloc_dma 182
pgalloc_normal 76067
pgalloc_high 326333
pgalloc_movable 0
pgfree 1108260
pgactivate 53201
pgdeactivate 2592
pgfault 420060
pgmajfault 4323
pgrefill_dma 0
pgrefill_normal 2589
pgrefill_high 0
pgrefill_movable 0
pgsteal_kswapd_dma 0
pgsteal_kswapd_normal 0
pgsteal_kswapd_high 0
pgsteal_kswapd_movable 0
pgsteal_direct_dma 0
pgsteal_direct_normal 1211
pgsteal_direct_high 7987
pgsteal_direct_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 4172
pgscan_direct_high 25365
pgscan_direct_movable 0
pgscan_direct_throttle 0
pginodesteal 0
slabs_scanned 9728
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
pageoutrun 1
allocstall 189
pgrotated 7
drop_pagecache 0
drop_slab 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 64
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 64
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.model"
$(getprop ro.product.brand) $(getprop ro.product.model)
EOF
cat <<- EOF > "${PREFIX}/share/${directory}/proc/.version"
Linux version 5.10.0 (termux@android) (gcc version 4.9 (GCC)) $(uname -v)
EOF
cat <<- EOF > "${PREFIX}/bin/start-${directory}"
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --kernel-release=5.10.0"
command+=" --link2symlink"
command+=" --kill-on-exit"
command+=" --rootfs=${PREFIX}/share/${directory}"
command+=" --root-id"
command+=" --bind=/dev"
command+=" --bind=/dev/urandom:/dev/random"
command+=" --bind=/proc"
command+=" --bind=/proc/self/fd:/dev/fd"
command+=" --bind=/proc/self/fd/0:/dev/stdin"
command+=" --bind=/proc/self/fd/1:/dev/stdout"
command+=" --bind=/proc/self/fd/2:/dev/stderr"
command+=" --bind=/sys"
command+=" --bind=/sdcard"
command+=" --bind=/data/data/com.termux"
command+=" --bind=${PREFIX}/share/${directory}/tmp:/dev/shm"
if ! cat /proc/loadavg > /dev/null 2>&1; then
command+=" --bind=${PREFIX}/share/${directory}/proc/.loadavg:/proc/loadavg"
fi
if ! cat /proc/stat > /dev/null 2>&1; then
command+=" --bind=${PREFIX}/share/${directory}/proc/.stat:/proc/stat"
fi
if ! cat /proc/uptime > /dev/null 2>&1; then
command+=" --bind=${PREFIX}/share/${directory}/proc/.uptime:/proc/uptime"
fi
if ! cat /proc/vmstat > /dev/null 2>&1; then
command+=" --bind=${PREFIX}/share/${directory}/proc/.vmstat:/proc/vmstat"
fi
command+=" --bind=${PREFIX}/share/${directory}/proc/.model:/proc/device-tree/model"
command+=" --bind=${PREFIX}/share/${directory}/proc/.version:/proc/version"
command+=" /usr/bin/env -i"
command+=" TERM=\$TERM"
command+=" /bin/su --login"
com="\$@"; [ -z "\$1" ] && exec \$command || \$command "\$com"
EOF
termux-fix-shebang "${PREFIX}/bin/start-${directory}"
chmod 700 "${PREFIX}/bin/start-${directory}"
printf "\e[34m[\e[32m*\e[34m]\e[36m Installation successfully.\n\n\e[0m"
printf "\e[36mNow run \e[32mstart-${directory}\e[36m to login.\n\n\e[0m"
