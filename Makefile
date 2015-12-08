DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

deploy:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
		mkdir -p .vim/bundle
		git clone https://github.com/Shougo/neobundle.vim.git .vim/bundle/neobundle.vim

init:
		@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)
