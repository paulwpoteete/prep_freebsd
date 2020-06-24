# set color
color_prompt=yes
force_color_prompt=yes

### A colon-separated list of values controlling how commands are saved on the history list. If the list of values includes ignorespace, lines which begin with a space character are not saved in the history list. A value of ignoredups causes lines matching the previous history entry to not be saved. A value of ignoreboth is shorthand for ignorespace and ignoredups. A value of erasedups causes all previous lines matching the current line to be removed from the history list before that line is saved. https://askubuntu.com/questions/15926/how-to-avoid-duplicate-entries-in-bash-history
export HISTCONTROL=ignoreboth:erasedups

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

alias ll='ls -lh --color'
alias grep='grep --color -E'
alias find='time find'
alias mv='mv -i'
alias cp='cp -i'
alias vi='vim'
alias dd='dd status=progress'
alias nmap='nmap --open'
alias logout='func_write && history >> ~/.history.save && logout'
alias x='func_write && history >> ~/.history.save && \exit'
alias exit='func_write && history >> ~/.history.save && exit'

### Prompt Modifications Start ###
#--------------------------------#
# 20170828 Paul W. Poteete. Note: install net-tools for Linux distros that are misled.
### Alternative Bash Prompt Command ###
#PROMPT_COMMAND='echo -en "\e[2m\e[7m[Session Line:$LINENO Date:`date`]\n" '

#--------------------------------#
### BSD/Linux Bash Prompt Command ###
var_ip=`/sbin/ifconfig -a | grep inet| grep -v ":|127.0.0.1" | awk '{ printf $2", " }' | rev | cut -c 3- | rev`
PROMPT_COMMAND='if [ ${EUID} == 0 ]; then echo -en "\e[49m\e[31m[`uname -s` Line:$LINENO Date:`date`\e[1m IP:$var_ip\e[0m\e[31m]\e[0m\n"; else echo -en "\e[100m\e[37m[Session Line:$LINENO Date:`date`\e[1m IP:$var_ip\e[0m\e[100m\e[37m]\e[0m\n" ; fi'
var_system=`uname -s | grep -ic linux`
#--------------------------------#

#--------------------------------#
if [ $var_system -eq '1' ]
then
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
#--------------------------------#
### Prompt Modifications Stop. ###
