read -r -d '' CMD <<'EOF'
cd /data/backup
cp /usr/bin/vim /usr/bin/vim_bak
echo 'ddxd2015' | sudo -S yum install -y ncurses-devel

tar xvzf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
./configure
make -j 4
echo 'ddxd2015' | sudo -S make install

cd ..

export LIBEVENT_CFLAGS="-I/usr/local/include"
export LIBEVENT_LIBS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib -levent"

tar xvfz tmux-2.2.tar.gz
cd tmux-2.2
./configure
make -j 4
echo 'ddxd2015' | sudo -S make install
EOF

for i in dev node2
do
  ssh -t $i "$CMD"
done
