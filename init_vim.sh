#!env bash -xv
set -e

if ! commanc -v install_vim_plugin > /dev/null 2>&1; then
  echo "install_vim_plugin not found"
  exit 1
fi

base_url="https://github.com"

for i in (ctrlpvim/ctrlp.vim fatih/vim-go terryma/vim-multiple-cursors tpope/vim-surround wellle/targets.vim isRuslan/vim-es6 SirVer/ultisnips); do
  install_vim_plugin "$base_url/$i"
done

cd ~/.vim && rm -rf ~/.vim/UltiSnips && git clone https://github.com/lutaoact/vim-snippets.git UltiSnips
