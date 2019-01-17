# Take Me To Your Leader

Do you have lots of leader mappings? Is your .vimrc growing exponentially by the
day? Step right up, because I have your solution. `Take Me To Your Leader` is
your new leader mapping control center, helping your vimrc stay organized and
easy to read!

This plugin will keep your mappings in user-defined sections, sort the sections
alphabetically, and then sort mappings within each section as well. Finally, it
will highlight your section titles to make your vimrc that much more readable.

## Usage

Extremely simple! Once you've [installed](#installation) and [setup](#setup),
just open the file with your leader mappings and run:

```vim
:SortLeaderCommands
```

Might I recommend an auto command? Tweak it as you please.

```vim
execute "autocmd InsertLeave" g:leader_location ":SortLeaderCommands"
```

## Options

#### Highlighting

To turn off highlighting:

```vim
let g:leader_highlight = 0
```

## Installation

Use your favorite package manager.

Using Vundle, add:

```vim
Plugin 'https://github.com/theryangeary/take-me-to-your-leader'
```

Then execute `:VundleInstall`

## Setup

To use this plugin, you first have to do 3 things:

------------------------------------------------------------------------------
1. Wrap your list of leader commands in a preceding comment that includes
"leader-begin", and follow the comment with an empty line, and a succeeding
comment that includes "leader-end" and precede the comment with an empty
line.

For example:

```vim
  " leader-begin

  nnoremap <leader>a :echo "Hello World"

  " leader-end
```

The dashes can actually be any single non-newline character if using a dash
doesn't suit you.

------------------------------------------------------------------------------
2. Organize leader commands into logical sections (paragraphs) with a header
(comment) and put comments inline with mappings.

Example:

```
  " File
  nnoremap <leader>c :bdelete| " close the current file
  nnoremap <leader>s :write

  " Git
  nnoremap <leader>ga :!git add %| " add current file to git repo
  nnoremap <leader>gp :!git push
```

Here we have two sections, each with a header ("File" and "Git").
Additionally, comments are placed inline with mappings.

------------------------------------------------------------------------------
3. Set location of leader mappings.

Add the following line to the file where your leader mappings are.
NOTE: This is not necessary if you keep your leader mappings in $MYVIMRC

```
  let g:leader_location = expand("<sfile>:p")
```

------------------------------------------------------------------------------
