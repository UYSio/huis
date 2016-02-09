#!/usr/bin/env python3
# Author: Juan Matthys Uys <opyate+huis@gmail.com>
# Main script for https://github.com/uysio/huis
# Tested on:
#+ Arch Linux
#+ Ubuntu 14.04
#+ Mac OSX 10.10.4

from urllib.request import (
    urlopen,
    Request
)
import json
import subprocess
import os
import errno
import sys


API_BASE = 'https://api.github.com'

APIS = {
    'repos': API_BASE + '/users/{username}/repos'
}
HEADERS = { 'Accept': 'application/vnd.github.v3+json' }

def log(msg):
    print('>>>\t%s' % msg)

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

def make_sure_path_exists(path):
    """Try to create the directory, but if it already exists,
    we ignore the error. On the other hand, any other error
    gets reported.

    """
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise

def get_immediate_subdirectories(a_dir):
    for name in os.listdir(a_dir):
        if os.path.isdir(os.path.join(a_dir, name)):
            yield name

def api(which, **kwargs):
    return APIS[which].format(**kwargs)

def read_usernames():
    """Asks for one username, even though multiple usernames
    are supported. This is because the modules doesn't
    support the case where there's a module name clash.

    """
    if len(sys.argv) > 1:
        for username in sys.argv[1:]:
            yield username
    else:
        usernames = input("Github user or org name for huis modules: ")
        for sub in usernames.split(','):
            for username in sub.split():
                yield username

def repos(username):
    endpoint = api('repos', username=username)
    log('GET %s' % endpoint)
    request = Request(
            endpoint,
            headers=HEADERS)
    response = urlopen(request).read().decode('utf-8')
    data = json.loads(response)
    for datum in data:
        yield datum

def get_module_info(repo_name):
    """Given a repo name, gives module information for it:
      - local path to module
      - does the module exist?

    Assumes os.chdir was called so work happens in the
    right place.

    """
    # TODO use os.sep
    modules_path = 'modules/{repo_name}'
    path = modules_path.format(repo_name=repo_name)
    exists = os.path.exists(path)
    return {
        'path': path,
        'exists': exists
    }

def clone_or_update(username, whitelist='huis-'):
    """Clones modules with names starting with 'whitelist'
    in the repository for user with 'username'.

    Assumes os.chdir was called so work happens in the
    right place.

    """
    for repo in repos(username):
        repo_name = repo['name']
        repo_clone_url = repo['clone_url']

        if repo_name.startswith(whitelist):
            info = get_module_info(repo_name)
            rel = info['path']
            exists = info['exists']
            # check if this repo has already been cloned
            log('Checking if path=[%s] exists...' % rel)
            if exists: 
                log('TODO update %s' % rel)
            else:
                log('cloning %s to %s' % (repo_clone_url, rel))
                try:
                    args = ['git', 'clone','--recursive', repo_clone_url, rel]
                    print(subprocess.check_output(args))
                except subprocess.CalledProcessError as e:
                    log('Error cloning: %s' % e.output)

def run_module(module_name, modules_dir):
    """Runs a module inside 'modules_dir'.

    """
    with cd(modules_dir):
        with cd(module_name):
            pwd = os.getcwd()
            log('Run module=[%s] in pwd=[%s]' % (module_name, pwd))
            try:
                print(subprocess.check_output(['./huis.sh']))
            except subprocess.CalledProcessError as e:
                log('Error run module: %s' % e.output)

def run_all_modules(huis_dir):
    """Runs huis.sh in each module

    """
    modules_dir = huis_dir + '/modules'
    modules_list = list(get_immediate_subdirectories(modules_dir))

    # extract huis-first and huis-last, if they exist
    _first = 'huis-first'
    _last = 'huis-last'
    has_last = False

    if _first in modules_list:
        modules_list.remove(_first)
        run_module(_first, modules_dir)

    if _last in modules_list:
        modules_list.remove(_last)
        has_last = True

    # run the rest of the modules
    for module_name in modules_list: 
        run_module(module_name, modules_dir)

    if has_last:
        run_module(_last, modules_dir)
                

def main():
    home_dir = os.path.expanduser('~')
    huis_dir = os.path.join(home_dir, '.huis')
    for username in read_usernames():
        log('Clone or update for username=[%s]' % username)
        clone_or_update(username)
    run_all_modules(huis_dir)

if __name__ == '__main__':
    # TODO check this is run from ~/.huis
    main()

