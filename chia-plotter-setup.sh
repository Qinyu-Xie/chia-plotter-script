sudo apt-get install smartmontools
sudo apt-get install htop
sudo apt-get install cifs-utils
sudo apt-get install nload
sudo apt-get install -y inotify-tools

ulimit -n 10000
sudo mkdir /mnt/smb_d24_0/

sudo mkdir /media/qinyu/ssd0/dest/
# chmod -R a+rwX /mnt/smb_d24_0/

sudo mount -t cifs //192.168.0.24/share /mnt/smb_d24_0/ -o uid=qinyu,gid=qinyu,guest

sudo apt install -y libsodium-dev cmake g++ git

cd ~

git clone https://github.com/madMAx43v3r/chia-plotter.git 

cd chia-plotter

git submodule update --init
./make_devel.sh




echo "nohup ./build/chia_plot -n -1 \-r 16 -u 128 -t /media/qinyu/ssd0/ -2 /media/qinyu/ssd1/ -d /media/qinyu/ssd0/dest/ -p a795a9669ec652c07bd9a9e78c7c8317e76e8ee628af1759b8375b119e1b043460fac837916af2cb73372b59d68a6135 -f 824be3ba2cfb3d615f945a0ea7813c0bf7091ce385e001a6c784364e095cf43e3e575c14e63ccaabef025d48e74db377 &" > run_plotter.sh

mkdir sync



cd ./sync

echo "
inotifywait -m /media/qinyu/ssd0/dest/ -e create -e moved_to |
    while read path action file; do
        if [["\$file" =~ .*plot$ ]]; then # Does the file end with .plot?
            mv /media/qinyu/ssd0/dest/\$file /mnt/smb_d24_0/ # If so, do your thing here!
        fi
    done
" > sync-fg.sh

echo "nohup bash ./sync-fg.sh &" > sync.sh
