###################################
### PWP Modifications v20200101 ###
###################################
# These settings modify the bash prompt to allow for ease of use.
# The options are written with ease of understanding in mind.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000000
HISTFILESIZE=2000000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set color
color_prompt=yes
force_color_prompt=yes

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### Attempt to verify ownership after performing sudo operations
### Most commonly: .bash_history .viminfo .history.save
function func_write {
        echo "Attempting to Write History and Verify Ownership..."
        IFS=$'\n'
        var_own=`ls -lA ~/ | awk '{ print $3,$4 }' | grep -v $USER | wc -l`
        if [ $var_own -gt 1 ]
        then
		sudo umount /home/$USER/.gvfs 2>/dev/null
		sudo chown $USER.$USER /home/$USER -Rc 2>/dev/null
        fi
        unset IFS
}
alias logout='func_write && history >> ~/.history.save && logout'
alias x='func_write && history >> ~/.history.save && \exit'
alias exit='func_write && history >> ~/.history.save && exit'

### PROMPT_COMMAND ###
#-------------------------------------------------------------------------------------------------------------------#
	# 20170828 Paul W. Poteete
	# Note: install net-tools for Linux distros that are misled.
	# Alternative Bash PROMPT_COMMAND #
	# PROMPT_COMMAND='echo -en "\e[2m\e[7m[Session Line:$LINENO Date:`date`]\n" '

	### Color Notes ###
	# Blk Background = \e[49m
	# Red Foreground = \e[31m
	# Drk Gray Background = \e[100m
	# Lgt Gray Foreground = \e[37m
	# Bold = \e[1m
	# Norm = \e[0m

var_system=`uname -s | grep -ic linux`
	rb='\e[1m\e[49m\e[31m'  # Root Bold = \e[1m\e[49m\e[31m
	rn='\e[0m\e[49m\e[31m'  # Root Norm = \e[0m\e[49m\e[31m
	ub='\e[1m\e[100m\e[37m' # User Bold = \e[1m\e[100m\e[37m
	un='\e[0m\e[100m\e[37m' # User Norm = \e[0m\e[49m\e[31m

if [ $var_system -eq '1' ]
then
	### Linux PROMPT_COMMAND ###
	var_date=`date +%a,%Y%m%d.%H%Mhrs`
	var_ram=`free -h --si | grep Mem | awk '{ print $3 }'`
	var_ip=`/sbin/ifconfig -a | grep inet| grep -v ":|127.0.0.1" | awk '{ printf $2", " }' | rev | cut -c 3- | rev`
	PROMPT_COMMAND='if [ ${EUID} == 0 ];
	then echo -en "$rn[OS:`uname -s` Date:$var_date FreeRAM:"$var_ram" $rb\0IP:$var_ip$rn]\e[0m\n";
	else echo -en "$un[OS:`uname -s` Date:$var_date FreeRAM:"$var_ram" $ub\0IP:$var_ip$un]\e[0m\n" ; fi'
else
	### BSD PROMPT_COMMAND ###
	var_date=`date +%a,%Y%m%d.%H%Mhrs`
	var_ip=`/sbin/ifconfig -a | grep inet| grep -v ":|127.0.0.1" | awk '{ printf $2", " }' | rev | cut -c 3- | rev`
	PROMPT_COMMAND='if [ ${EUID} == 0 ];
	then echo -en "$rn[OS:`uname -s` Line:$LINENO Date:$var_date $rb\0IP:$var_ip$rn]\e[0m\n";
	else echo -en "$un[OS:`uname -s` Line:$LINENO Date:$var_date $ub\0IP:$var_ip$un]\e[0m\n" ; fi'
fi

### PROMPT (PS1) ###
#-------------------------------------------------------------------------------------------------------------------#
if [ $var_system -eq '1' ]
then
	### aliases for Debian-Based systems ###
	alias ll='ls -lh --color --group-directories-first'
	alias grep='grep --color -E'
	alias find='time find'
	alias mv='mv -i'
	alias cp='cp -i'
	alias vi='vim'
	alias apt-get='sudo apt-get'
	alias dpkg='sudo dpkg'
	alias aptitude='sudo aptitude'
	alias screen='screen -L'
	alias dd='dd status=progress'
	alias nmap='nmap --open'
	alias d='dict'
	alias yt='torsocks youtube-dl'
	alias rsyncr='rsync -huvr --remove-source-files --progress'
	
	### Linux Bash Prompt ###
PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$ \[\e[0m\]"

	### Linux Bash Prompt Notes###
	#sym1=\342\224\214 # up-right bracket
	#sym2=\342\224\200 # straight line
	#sym3=\342\224\224 # down-right bracket
	#sym4=\342\225\274 # bulb-tip line
else
	### BSD Bash Prompt ###
PS1="\[\033[0;31m\]+-\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]-\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]-[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]+-\[\033[0m\]\[\e[01;33m\]\\$ \[\e[0m\]"
fi
#-------------------------------------------------------------------------------------------------------------------#
