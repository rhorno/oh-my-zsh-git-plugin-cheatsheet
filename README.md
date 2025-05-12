# Oh My Zsh Git Plugin Cheatsheet

A simple command-line tool for displaying all the git aliases and functions available in the Oh My Zsh git plugin.

## Features

- Shows all git aliases and functions from the Oh My Zsh git plugin
- Search for specific commands (e.g., `gcheat commit`)
- Fast response times with built-in caching mechanism

## Why Use This Tool?

The Oh My Zsh git plugin provides hundreds of helpful aliases and functions to make your Git workflow more efficient. This tool helps you quickly find the right command when you need it.

## Installation

Clone this repository and set up the alias in your `.zshrc`:

```bash
# Clone the repository
git clone https://github.com/rhorno/oh-my-zsh-git-plugin-cheatsheet.git ~/oh-my-zsh-git-plugin-cheatsheet

# Add the alias to your .zshrc (use the full path to the script)
echo 'alias gcheat="$HOME/oh-my-zsh-git-plugin-cheatsheet/oh-my-zsh-git-plugin-cheatsheet.sh"' >> ~/.zshrc

# Reload your shell configuration
source ~/.zshrc
```

Note: You may need to make the script executable:

```bash
chmod +x ~/oh-my-zsh-git-plugin-cheatsheet/oh-my-zsh-git-plugin-cheatsheet.sh
```

## Usage

### Basic Usage

Simply run:

```
gcheat
```

This will display all git aliases and functions.

### Search Functionality

To search for specific commands, add a search term:

```
gcheat commit
```

This will show only commands related to "commit".

## Cache Management

The script maintains a cache file in the same directory as the script. If you want to force a refresh of the cache, simply delete the cache files:

```
rm git_aliases_cache.txt git_aliases_cache_date.txt
```
