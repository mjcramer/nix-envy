#!/usr/bin/env bash

# Shows the most recent branches having commits 
git for-each-ref --sort=-committerdate refs/heads/
