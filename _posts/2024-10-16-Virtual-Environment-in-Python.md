---
title: Python 虚拟环境
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
img_path: 
---

```shell
➜  ~ python -m venv tutorial-env

The virtual environment was not created successfully because ensurepip is not
available.  On Debian/Ubuntu systems, you need to install the python3-venv
package using the following command.

    apt install python3.8-venv

You may need to use sudo with that command.  After installing the python3-venv
package, recreate your virtual environment.

Failing command: ['/home/sense/tutorial-env/bin/python', '-Im', 'ensurepip', '--upgrade', '--default-pip']

➜  ~ sudo apt install python3.8-venv -y
```

activate & deactivate

```shell
➜  Desktop cd tutorial-env
➜  tutorial-env head ./bin/activate
# This file must be used with "source bin/activate" *from bash*
# you cannot run it directly

deactivate () {
    # reset old environment variables
    if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="${_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
➜  tutorial-env source ./bin/activate     
(tutorial-env) ➜  tutorial-env deactivate
➜  tutorial-env 
```

