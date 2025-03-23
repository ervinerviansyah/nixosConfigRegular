{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in 

{
  # Informasi tentang home-manager
    home.username = "ervin";
    home.homeDirectory = "/home/ervin";
    home.stateVersion = "24.11";   
    home.enableNixpkgsReleaseCheck = false;
 
  # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  # Allow broken packages
    nixpkgs.config.allowBroken = true;
  # Install Elektron
    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];
    
  # Fonts config
    fonts.fontconfig.enable = true;  

  # Instalasi packages maupun software
    home.packages = with pkgs; [
      # Text Editor
      unstable.vscode

      # Software Desain Grafis
      gimp-with-plugins
      inkscape
      scribus
      krita
      darktable
      blockbench
      pureref

      # Plugin Desain Grafis
      gimpPlugins.resynthesizer

      # Audio Mixing
      audacity

      # Video Editing
      obs-studio
      kdePackages.kdenlive
      vlc
      handbrake
      synfigstudio

      # Essential Sistem
      htop
      neofetch
      fastfetch
      git
      unzip
      wget
      ntfs3g
      p7zip-rar

      # Personal Use
      bitwarden-desktop
      zapzap
      telegram-desktop
      gabutdm
      discord
      spotify
      warpinator
      super-productivity
      blanket
      collision
      curtail
      shortwave
      gnome-boxes
      linuxKernel.packages.linux_6_6.virtualboxGuestAdditions
      ventoy-full
      unetbootin
      gparted
      woeusb-ng
      impression
      qbittorrent

      # Browser
      brave

      # Kebutuhan Pemrograman
      ripgrep
      gnumake
      gcc
      zig
      python314
      jdk
      xclip
      direnv
      lua
      db
      fd
      libcxxStdenv

      # Python
      ruff
      python312Packages.jedi-language-server
      basedpyright
      python312Packages.python-lsp-server
      pylyzer
      pyright

      # HTML
      vscode-langservers-extracted
      ltex-ls
      tailwindcss-language-server

      # C & C++
      ccls
      sourcekit-lsp
      clang-tools

      # Go
      gopls

      # Tambahan NvChad
      nodejs_23
      lua-language-server
      luajitPackages.luarocks
      wl-clipboard
      luajitPackages.lua-lsp
      live-server

      # Pemantauan Sistem
      vnstat
      qdiskinfo

      # Terminal
      kitty

      # Shell & Pendukung
      fish
      eza
      bat
      trash-cli
      starship
      zoxide

      # Pendukung Nix
      comma 
      nix-index

      # Wine
      wineWowPackages.stable
      winetricks
      mono

      # Kepenulisan
      unstable.libreoffice-fresh
      zotero
      logseq

      # Game
      lutris
      prismlauncher
      godot_4
      steam-run

      # Fonts
      corefonts
      vistafonts
      nerdfonts  
      google-fonts

  ];

  # Konfigurasi dots file 
  home.file = {
    
    };

  # home.sessionVariables = {
  #   EDITOR = "neovim";
  #};

  # Konfigurasi Packages
    # Home Manager
    programs.home-manager.enable = true;

    # Starship
    programs.starship = {
	enable = true;
	enableFishIntegration = true;
    };

    # Zoxide
    programs.zoxide = {
    	enable = true;
	enableFishIntegration = true;
    };

    # Neovim
    programs.neovim = {
	enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
	withPython3 = true;
	plugins = with pkgs.vimPlugins; [
	  neovim-sensible # Buat ada number line, tanda tab, dan fitur tab.
	  nvim-surround # Buat biar langsung tutup kurung
	  nvim-treesitter # Buat syntax highlight

          {
            plugin = nvim-tree-lua;
            type = "lua";
            config = ''
              vim.g.loaded_netrw = 1
              vim.g.loaded_netrwPlugin = 1

              vim.opt.termguicolors = true

              require("nvim-tree").setup({
                sort = {
                  sorter = "case_sensitive",
                },
                view = {
                  width = 30,
                },
                renderer = {
                  group_empty = true,
                },
                filters = {
                  dotfiles = true,
                },
              })
            '';
          }


        # Settingan LSP start
	  {
	    plugin = cmp-nvim-lsp;
	    type = "lua";
	    config = ''
  		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		require('lspconfig')['pyright'].setup {
    		capabilities = capabilities
  	  	}
	    '';
	    }

	vim-vsnip
	cmp-vsnip

	  {
	  	plugin = nvim-cmp;
		type = "lua"; # "lua", "viml", "teal", "fennel"
		config = ''
		-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

        -- For `mini.snippets` users:
        -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
        -- insert({ body = args.body }) -- Insert at cursor
        -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
        -- require("cmp.config").set_onetime({ sources = {} })
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })
		'';
	  }

	  {
	    plugin = lazy-lsp-nvim;
	    type = "lua";
	    config = ''
	      require('lazy-lsp').setup {

	      }
	    '';
	  }
          # Settingan LSP done

          # Settingan Treesitter
          nvim-treesitter-parsers.cpp
          nvim-treesitter-parsers.html
          nvim-treesitter-parsers.css
          nvim-treesitter-parsers.c_sharp
          nvim-treesitter-parsers.fish
          nvim-treesitter-parsers.gdscript
          nvim-treesitter-parsers.git_config
          nvim-treesitter-parsers.git_rebase
          nvim-treesitter-parsers.gitattributes
          nvim-treesitter-parsers.gitcommit
          nvim-treesitter-parsers.gitignore
          nvim-treesitter-parsers.go
          nvim-treesitter-parsers.java
          nvim-treesitter-parsers.javascript
          nvim-treesitter-parsers.json
          nvim-treesitter-parsers.lua
          nvim-treesitter-parsers.make
          nvim-treesitter-parsers.markdown
          nvim-treesitter-parsers.nix
          nvim-treesitter-parsers.php
          nvim-treesitter-parsers.python
          nvim-treesitter-parsers.rust
          nvim-treesitter-parsers.ruby
          nvim-treesitter-parsers.typescript
          nvim-treesitter-parsers.vim


          # Nvim Telescope
          {
            plugin = telescope-nvim;
            type = "viml";
            config = ''
            nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

            '';
          }

          # Nvim Autopairs
          {
            plugin = nvim-autopairs;
            type = "lua";
            config = ''
            require("nvim-autopairs").setup {}
            '';
          }

         # Settingan panel bar area bawah
	  vim-airline
	  {
	    plugin = vim-airline-themes;
	    config = "let g:airline_themes='wombat'";
	  }
	  vim-airline-clock
	  #vim-commentary
	  vim-fugitive
	  vim-gitgutter

	  {
            plugin = vim-indent-guides;
            config = ''
            let g:indent_guides_enable_on_vim_startup = 1
            '';
          }

          # Settingan tema Neovim
          {
            plugin = catppuccin-nvim;
            config = ''
              syntax enable
              colorscheme catppuccin
            '';
          }

      ];
        extraConfig = ''
          set cursorline
          set scrolloff=5
        '';
    };
  
}
