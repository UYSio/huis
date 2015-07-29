#!/usr/bin/env python
# Author: Juan Matthys Uys <opyate+huis@gmail.com>
# Main script for https://github.com/uysio/huis
# Tested on Ubuntu 14.04 and Mac OSX 10.10.4

import requests
import subprocess
import os


API_BASE = 'https://api.github.com'

APIS = {
    'repos': API_BASE + '/users/{username}/repos'
}
HEADERS = { 'Accept': 'application/vnd.github.v3+json' }
MODULE_PATH = 'modules/{repo_name}'

def api(which, **kwargs):
    return APIS[which].format(**kwargs)

def usernames():
    usernames = raw_input("Github username for huis modules:\n\n")
    for sub in usernames.split(','):
        for username in sub.split():
            # don't yield. Return first
            return username

def repos(username):
    r = requests.get(
            api('repos', username=username),
            headers=HEADERS)
    for obj in r.json():
        yield obj

def clone_or_update():
    for username in usernames():
        for repo in repo(username):
            repo_name = repo['name']
            repo_clone_url = repo['clone_url']

            if repo_name.startswith('huis-'):
                rel = MODULE_PATH.format(repo_name=repo_name)
                # check if this repo has already been cloned
                if os.path.exists(rel):
                    print('TODO update %s' % rel)
                else:
                    #print('cloning %s to %s' % (repo_clone_url, rel))
                    subprocess.call(['git', 'clone','--recursive', repo_clone_url, rel])

def run():
    # run huis.sh in each module
    pass

def main():
    clone_or_update()
    run()

if __name__ == '__main__':
    main()

