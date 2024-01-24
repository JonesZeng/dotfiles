#!/bin/bash

ENV_HOME=/workspace/env
CONDA_HOME=${ENV_HOME}/miniconda3
PYTHON=${ENV_HOME}/miniconda3/bin/python

cmd_test_block='curl www.youtube.com'
if [[ `cmd_test_block` -eq '0' ]]; then
	echo "======= Blocked ======="
	need_proxy=1
else
	echo "======= Not blocked ======="
	need_proxy=0
fi

# === proxy settings ===
proxy=http://127.0.0.1:7890
proxy_on='export HTTP_PROXY=${proxy}; HTTPS_PROXY=${proxy}; '
proxy_off='unset http_proxy; unset https_proxy; unset HTTP_PROXY; unset HTTPS_PROXY'

[ "$need_proxy" -eq "1" ] && eval $proxy_on

# ==== Install APPs
echo "======= Brew installing ======="
# Homebrew/Linuxbrew
if [ "$need_proxy" -eq "1" ]; then
	export HOMEBREW_INSTALL_FROM_API=1
	export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
	export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
	git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
	/bin/bash brew-install/install.sh
	rm -rf brew-install
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install the_silver_searcher fasd fzf nvim vim nodejs chezmoi tmux

# ===== apply dotfiles
chezmoi init https://github.com/JonesZeng/dotfiles.git
chezmoi apply

chsh -s $(which zsh)

# sed config home
# sed -in-place -e "s#HOME=/Users/zenghaolun02#HOME=${HOME}#g" ${HOME}/.zshrc
[ -f ~/.config/nvim/_machine_specific.vim ] && sed -in-place -e "s#/Users/zenghaolun02/opt#${ENV_HOME}#g" ${HOME}/.config/nvim/_machine_specific.vim

# === miniconda3
echo "====== Install conda ======"
cd ${ENV_HOME}
if [[ `uname` == 'Linux' ]]; then
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda3.sh
else if [[ `uname` == 'Darwin' ]]; then
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o miniconda3.sh
fi

if [ ! -d "${CONDA_HOME}" ]; then
	chmod +x ${ENV_HOME}/miniconda3.sh
	/bin/bash ${ENV_HOME}/miniconda3.sh -b -p ${ENV_HOME}/miniconda3
fi
[ "$need_proxy" -eq "1" ] && ${PYTHON} -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
${PYTHON} -m pip install neovim ranger-fm 
${CONDA_HOME}/bin/conda init zsh
rm -f miniconda3.sh


# === zim ===
echo "====== Install zim ======"
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
else
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
zsh
zimfw install


# === proxy
eval $proxy_off

