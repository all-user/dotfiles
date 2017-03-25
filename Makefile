DOTFILES_EXCLUDES := .DS_Store .git .gitmodules
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

deploy:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
		@$(foreach val, $(wildcard .dotfiles/install/*), $(val);)

init:
		@$(foreach val, $(wildcard .dotfiles/init/*), $(val);)
