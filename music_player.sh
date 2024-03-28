#! /bin/bash

currentdir=$(
cd $(dirname $0)
pwd
)
source $currentdir/bin/st_geometry

close_music() {
    ncmpcpp_pid=$(ps -u $USER -o pid,comm | grep 'ncmpcpp' | awk '{print $1}')
    mpd_pid=$(ps -u $USER -o pid,comm | grep 'mpd' | awk '{print $1}')
    cava_pid=$(ps -u $USER -o pid,comm | grep 'cava' | awk '{print $1}')
    killed=1
    if [ "$ncmpcpp_pid" ]; then
        kill -9 $ncmpcpp_pid
        killed=0
    fi
    if [ "$mpd_pid" ]; then
        kill -9 $mpd_pid
        killed=0
    fi
    if [ "$cava_pid" ]; then
        kill -9 $cava_pid
        killed=0
    fi
    return $killed
}
    # mpd: 这是音乐播放器守护进程（Music Player Daemon）的命令，用于启动MPD音乐服务器。

    # st: 这是一个终端仿真器（Terminal Emulator），可能是指的Suckless简洁终端。该命令用于打开终端并运行后续的命令。

    # -g $(st_geometry top_right 50 10): 这部分命令设置终端的位置和大小。它使用了st_geometry命令来指定终端的位置，可能是在屏幕的右上角，大小为50列10行。

    # -A 0.7: 这个选项设置终端的透明度为0.7，使得终端的内容可以透过看到下面的内容。

    # -t music -c FN: 这两个选项可能是设置终端的标题（title）为"music"，并指定了一个自定义的终端颜色方案（color scheme）"FN"。

    # -e 'ncmpcpp': 这部分命令在终端中运行ncmpcpp，这是一个基于ncurses的MPD客户端，用于控制MPD音乐服务器并浏览音乐库。

    # &: 这个符号表示将命令放入后台运行，以便继续执行下一个命令而不阻塞当前的Shell。

    # cava: 这是一个音乐可视化器，用于将音频数据可视化成图形效果。

    # -g $(st_geometry top_right 25 10 -50 0 -1): 这部分命令设置另一个终端的位置和大小，可能也是位于屏幕右上角，但是稍微靠左一些，大小为25列10行。

    # -A 0.7: 同样是设置终端的透明度为0.7。

    # -e cava: 在这个终端中运行cava音乐可视化器。

    open_music() {
        mpd
        st -g $(st_geometry top_right 50 10) -A 0.7 -t music -c FN -e 'ncmpcpp' &
        st -A 0.7 -c FN -g $(st_geometry top_right 25 10 -100 -50 -1) -e cava &
    }

    close_music || open_music
    $DWM/statusbar/statusbar.sh update music
