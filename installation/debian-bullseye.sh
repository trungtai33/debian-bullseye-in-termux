#!/data/data/com.termux/files/usr/bin/bash
directory="debian-bullseye"
if [ -d "$PREFIX/share/$directory" ]; then
printf "\n\e[31mError: distribution Debian Bullseye is already installed.\n\n\e[0m"
exit
fi
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Checking device architecture...\n\e[0m"
case $(uname -m) in
aarch64) arch="arm64v8" ;;
armv7l|armv8l) arch="arm32v7" ;;
i686) arch="i386" ;;
x86_64) arch="amd64" ;;
*)
printf "\e[34m[\e[32m*\e[34m]\e[31m Unsupported architecture.\n\n\e[0m"
exit ;;
esac
apt update > /dev/null 2>&1
apt install proot -y > /dev/null 2>&1
tarball="rootfs.tar.xz"
printf "\e[34m[\e[32m*\e[34m]\e[36m Downloading Debian Bullseye, please wait...\n\n\e[34m"
curl --fail --retry 5 --location --output "$tarball" \
"https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-$arch/bullseye/rootfs.tar.xz"
mkdir -p "$PREFIX/share/$directory"
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Installing Debian Bullseye, please wait...\n\e[31m"
proot --link2symlink tar -xf "$tarball" --directory="$PREFIX/share/$directory" --exclude='dev'||:
rm -f "$tarball"
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing profile file...\n\e[31m"
cat <<- EOF >> "$PREFIX/share/$directory/etc/profile"
export PULSE_SERVER="127.0.0.1"
export MOZ_FAKE_NO_SANDBOX="1"
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing resolv.conf file (DNS 1.1.1.1/1.0.0.1)...\n\e[31m"
cat <<- EOF > "$PREFIX/share/$directory/etc/resolv.conf"
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing hosts file...\n\e[31m"
cat <<- EOF > "$PREFIX/share/$directory/etc/hosts"
127.0.0.1 localhost
::1       ip6-localhost ip6-loopback
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing group file (GIDs)...\n\e[31m"
while read gid; do
cat <<- EOF >> "$PREFIX/share/$directory/etc/group"
root:x:$gid:
EOF
done < <(paste <(id -G | tr ' ' '\n'))
cat <<- EOF > "$PREFIX/share/$directory/proc/.model"
$(getprop ro.product.brand) $(getprop ro.product.model)
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.loadavg"
0.35 0.22 0.05 1/573 7767
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.stat"
cpu  165542 13183 24203 611072 152293 2164 191340 18252 0 0 0
cpu0 165542 13183 24203 611072 152293 2164 191340 18252 0 0 0
intr 6151816 155 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 234902 123428 52401 0 0 172134 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 122 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 146429 228361 164732 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 14082004 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ctxt 160720146
btime 1631785009
processes 153846
procs_running 2
procs_blocked 0
softirq 1857962 23 2536781 0 1723322 2457784 0 253 0 32144 1839876
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.uptime"
11965.80 11411.22
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.vmstat"
nr_free_pages 146031
nr_zone_inactive_anon 196744
nr_zone_active_anon 301503
nr_zone_inactive_file 2457066
nr_zone_active_file 729742
nr_zone_unevictable 164
nr_zone_write_pending 8
nr_mlock 34
nr_page_table_pages 6925
nr_kernel_stack 13216
nr_bounce 0
nr_zspages 0
nr_free_cma 0
numa_hit 672391199
numa_miss 0
numa_foreign 0
numa_interleave 62816
numa_local 672391199
numa_other 0
nr_inactive_anon 196744
nr_active_anon 301503
nr_inactive_file 2457066
nr_active_file 729742
nr_unevictable 164
nr_slab_reclaimable 132891
nr_slab_unreclaimable 38582
nr_isolated_anon 0
nr_isolated_file 0
workingset_nodes 25623
workingset_refault 46689297
workingset_activate 4043141
workingset_restore 413848
workingset_nodereclaim 35082
nr_anon_pages 599893
nr_mapped 136339
nr_file_pages 3086333
nr_dirty 8
nr_writeback 0
nr_writeback_temp 0
nr_shmem 13743
nr_shmem_hugepages 0
nr_shmem_pmdmapped 0
nr_file_hugepages 0
nr_file_pmdmapped 0
nr_anon_transparent_hugepages 57
nr_unstable 0
nr_vmscan_write 57250
nr_vmscan_immediate_reclaim 2673
nr_dirtied 79585373
nr_written 72662315
nr_kernel_misc_reclaimable 0
nr_dirty_threshold 657954
nr_dirty_background_threshold 328575
pgpgin 372097889
pgpgout 296950969
pswpin 14675
pswpout 59294
pgalloc_dma 4
pgalloc_dma32 101793210
pgalloc_normal 614157703
pgalloc_movable 0
allocstall_dma 0
allocstall_dma32 0
allocstall_normal 184
allocstall_movable 239
pgskip_dma 0
pgskip_dma32 0
pgskip_normal 0
pgskip_movable 0
pgfree 716918803
pgactivate 68768195
pgdeactivate 7278211
pglazyfree 1398441
pgfault 491284262
pgmajfault 86567
pglazyfreed 1000581
pgrefill 7551461
pgsteal_kswapd 130545619
pgsteal_direct 205772
pgscan_kswapd 131219641
pgscan_direct 207173
pgscan_direct_throttle 0
zone_reclaim_failed 0
pginodesteal 8055
slabs_scanned 9977903
kswapd_inodesteal 13337022
kswapd_low_wmark_hit_quickly 33796
kswapd_high_wmark_hit_quickly 3948
pageoutrun 43580
pgrotated 200299
drop_pagecache 0
drop_slab 0
oom_kill 0
numa_pte_updates 0
numa_huge_pte_updates 0
numa_hint_faults 0
numa_hint_faults_local 0
numa_pages_migrated 0
pgmigrate_success 768502
pgmigrate_fail 1670
compact_migrate_scanned 1288646
compact_free_scanned 44388226
compact_isolated 1575815
compact_stall 863
compact_fail 392
compact_success 471
compact_daemon_wake 975
compact_daemon_migrate_scanned 613634
compact_daemon_free_scanned 26884944
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 258910
unevictable_pgs_scanned 3690
unevictable_pgs_rescued 200643
unevictable_pgs_mlocked 199204
unevictable_pgs_munlocked 199164
unevictable_pgs_cleared 6
unevictable_pgs_stranded 6
thp_fault_alloc 10655
thp_fault_fallback 130
thp_collapse_alloc 655
thp_collapse_alloc_failed 50
thp_file_alloc 0
thp_file_mapped 0
thp_split_page 612
thp_split_page_failed 0
thp_deferred_split_page 11238
thp_split_pmd 632
thp_split_pud 0
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
thp_swpout 4
thp_swpout_fallback 0
balloon_inflate 0
balloon_deflate 0
balloon_migrate 0
swap_ra 9661
swap_ra_hit 7872
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.version"
Linux version 5.10.0 (build@debian) (gcc version 4.9 (GCC)) #1 SMP Thursday August 14 12:00:00 UTC 2020
EOF
bin="start-debian-bullseye"
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing $bin file...\n\e[0m"
cat <<- EOF > "$PREFIX/bin/$bin"
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --kernel-release=5.10.0"
command+=" --link2symlink"
command+=" --kill-on-exit"
command+=" --root-id"
command+=" --rootfs=$PREFIX/share/$directory"
command+=" --cwd=/root"
command+=" --bind=/dev"
command+=" --bind=/dev/urandom:/dev/random"
command+=" --bind=/proc"
command+=" --bind=/proc/self/fd:/dev/fd"
command+=" --bind=/proc/self/fd/0:/dev/stdin"
command+=" --bind=/proc/self/fd/1:/dev/stdout"
commamd+=" --bind=/proc/self/fd/2:/dev/stderr"
command+=" --bind=/sys"
command+=" --bind=/data/data/com.termux"
command+=" --bind=/sdcard"
command+=" --bind=$PREFIX/share/$directory/root:/dev/shm"
command+=" --bind=$PREFIX/share/$directory/proc/.model:/proc/device-tree/model"
if ! cat /proc/loadavg > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.loadavg:/proc/loadavg"
fi
if ! cat /proc/stat > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.stat:/proc/stat"
fi
if ! cat /proc/uptime > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.uptime:/proc/uptime"
fi
if ! cat /proc/vmstat > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.vmstat:/proc/vmstat"
fi
command+=" --bind=$PREFIX/share/$directory/proc/.version:/proc/version"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
exec \$command
EOF
termux-fix-shebang "$PREFIX/bin/$bin"
chmod 700 "$PREFIX/bin/$bin"
printf "\e[34m[\e[32m*\e[34m]\e[36m Installed successfully.\n\n\e[0m"
printf "\e[36mNow run \e[32m$bin\e[36m to login.\n\n\e[0m"
