# My Dotfiles

## Purpose
This repository is a collection of scripts and configuration files I use in my day-to-day work.
Collecting them in this fashion eases the transition from workstation to workstation.

I use [boxen](http://boxen.github.com) to provision my mac for development.
Some of my dotfiles assume boxen is present.

## Installation
### With boxen
I clone my dotfiles repo into `boxen::config::srcdir` (`~/src` is the default) and add directives to my [personal manifest](https://github.com/boxen/our-boxen/tree/master/modules/people) to make the necessary symlinks.
There are [a number of ways](https://github.com/boxen/our-boxen/issues/103) to integrate your personal dotfiles so that they work with boxen modules; do what works for you.

### Without boxen
Clone this repo into `~/git/dotfiles` (or wherever you like) and symlink from there.
**NOTE: Some things won't work.**
