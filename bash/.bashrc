# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export TERM=screen-256color

# #configuration for random animals
# if [ -x /usr/games/cowsay -a -x /usr/games/fortune ]; then
# 	fortune | cowsay -f `ls -1 /usr/share/cowsay/cows/ | sort -R | head -1` -n
# 	fi

export NISE_HOME=$HOME/git/neptune/nise
# export NISE_HOME=$HOME/git/rtiBranch/neptune/nise
alias nise="cd /home/changyungong/git/neptune/nise"
alias rti="cd /home/changyungong/git/rtiBranch/neptune/nise"
alias mmmm="make MODE=opt -j 4"

export NISE_NGINX_HOME=$HOME/experiment/nginx/nginx-1.10.1

#environment variable to install protobuf 2.5.0
export CPPFLAGS=-fPIC
export CXXFLAGS=-fPIC

# for perlbrew command
# source ~/perl5/perlbrew/etc/bashrc
source /home/changyungong/perl5/perlbrew/etc/bashrc

# alias commands
# alias fhere="find . -name"
# alias ps="ps auxf"
alias xad="sudo su - xad"

# xssh
export SVN_RANGE_ROOT="$HOME/sreRange/range"

# seastar
export SEASTAR_HOME=$HOME/experiment/seastar
alias seastar="g++ -g `pkg-config --cflags --libs $SEASTAR_HOME/seastar/build/release/seastar.pc`"

# docker seastar
# bash argument $1, $2, $3
# for all argument, "$@"
seabuild() {
    docker run --net=host -v $HOME/experiment/seastar/seastar/:/seastar -u $(id -u):$(id -g) -w /seastar -t seastar-dev "$@";
}

seacompile() {
    seabuild c++ `pkg-config --cflags --libs ./build/release/seastar.pc` "$@";
}

searun() {
    docker run  --name hello --net=host -v $HOME/experiment/seastar/seastar/:/seastar -u $(id -u):$(id -g) -w /seastar -t seastar-dev "$@";
}

alias docclean="docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)"
# seahttpd() {
#     docker run  --name sh --net=host -v $HOME/experiment/seastar/seastar/:/seastar -u $(id -u):$(id -g) -w /seastar -t seastar-dev "./build/release/apps/httpd/httpd --smp 2";
# }

alias seahttp="docker run  --net=host -v $HOME/experiment/seastar/seastar/:/seastar -u $(id -u):$(id -g) -w /seastar -t seastar-dev './build/release/apps/httpd/httpd --smp 2'"

# nginx fastcgi
cgicompile() {
    g++ "$@" -lfcgi++ -lfcgi -o a.out;
}

cgirun() {
    spawn-fcgi -p 8000 -n "$@";
}

#alias commands for nginx development
alias w="cd $NISE_HOME/nginxmod/lsnginxmod"
alias s="cd $NISE_HOME/tools/scripts/nginx_scripts"
alias n="cd /home/changyungong/experiment/nginx/nginx-1.10.1"
# export LD_LIBRARY_PATH=/home/changyungong/experiment/nginx/modules/library:/home/changyungong/git/neptune/nise/src/objs.x86_64:$LD_LIBRARY_PATH
export FASTBITLOGFILE=/home/xad/ibis/ibis.txt

#command for changyungong nise home
alias make_nise="make MODE=opt -j 4"


# commands for ssh agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}"  ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
        }
    else
        start_agent;
    fi

# login in to xad
alias xad="sudo su - xad"

# RTags
# alias rdm=/home/changyungong/git/rtags/build/bin/rdm
# alias rc=/home/changyungong/git/rtags/build/bin/rc 

function www() {
    WORK="work"

    tmux has-session -t "$WORK"
    if [ $? != 0  ]; then
        tmux new-session -s "$WORK" -n "main" -d
        tmux new-window -t "${WORK}:2" -n "xad" 

        tmux send-keys -t "${WORK}:2" "xad" C-m
    fi
    tmux attach -t $WORK
}
