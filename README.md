# Atom-Hydrogen-Docker Kernels
How to set up Dockerized remote Jupyter kernels, and connect to those kernels from local Atom editor.

## Steps
1. Create a local dockerfile that will build the appropriate docker container. This container will be the brains of the data science operation, but for Hydrogen to correctly connect to a remote kernel from within Atom, the kernel server must be daemonized.
2. Instructions to build the dockerfile can be found in the Hydrogen documentation.
  - https://nteract.gitbooks.io/hydrogen/docs/Usage/RemoteKernelConnection.html
  - The dockerfile in this directory is based on the Hydrogen example.
3. Tini is a good lightweight init manager, so that's the recommended choice.
4. Right now I'm using the `jupyter/datascience-notebook` image, as I'm assuming it'll have most of the tools I'll need to get started.
  - These jupyter images are already daemonized via tini.

  ##### Note:
The `docker run` command below doesn't actually use the dockerfile located here; instead, it just uses the default datascience notebook image. For other docker images, I'll have to actually build the image and include those instructions and dockerfiles here.

5. Install Atom and Hydrogen locally.
6. In the Hydrogen settings 'gateway' options, add this code:
```
[{
    "name": "Dockerized Jupyter Kernel",
    "options": {
      "baseUrl": "http://localhost:8888",
      "token": "my_secret_token"
    }
  }]
  ```
  - This tells Hydrogen where to contact the remote Jupyter kernel; not sure about this secret token thing yet...
7. This docker command spins up the `jupyter/datascience-notebook` container:
```
docker run -it --rm --name RemoteJupyter -p 8888:8888 -e JUPYTER_TOKEN=my_secret_token jupyter/datascience-notebook
```
  - run with the `-d` argument to run headless.
  - to mount a volume on Windows: `-v 'C:/Users/ZacHeacker/...path/...to/...directory:/data'`
  - to mount a volume on Linux: `-v /...path/...to/...directory:/data`
8. In Atom, from within a Python script, `ctrl-shift-p` to search for "remote kernel," and connect to the running docker container's Jupyter kernel.
9. `ctrl-enter` executes a single line of code. Check resources for other keyboard shortcuts.

## Resources
1. Docker documentation, offline:
  - Run `docker run -it --rm -d -p 4000:4000 docs/docker.github.io:latest`
  - Navigate to http://127.0.0.1:4000
2. Jupyter Docker Stacks: https://jupyter-docker-stacks.readthedocs.io/en/latest/
3. Tini github: https://github.com/krallin/tini/
4. Hydrogen docs: https://nteract.gitbooks.io/hydrogen/
5. Jupyter keyboard shortcuts: https://towardsdatascience.com/jypyter-notebook-shortcuts-bf0101a98330
