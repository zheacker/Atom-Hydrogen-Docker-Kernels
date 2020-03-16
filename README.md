# Atom-Hydrogen-Docker Kernels
How to set up Dockerized remote Jupyter kernels, and connect to those kernels from local Atom editor.

## General Steps
1. Create a local dockerfile that will build the appropriate docker container. For Hydrogen to correctly connect to a remote kernel from within Atom, the kernel server must be daemonized. Tini is a good leightweight init manager for this.
  - Instructions to build the dockerfile can be found in the Hydrogen documentation: https://nteract.gitbooks.io/hydrogen/docs/Usage/RemoteKernelConnection.html
  - The dockerfile should use tini as its `ENTRYPOINT`, and you can run other commands (e.g. `jupyter-notebook`) via `CMD` in the dockerfile or at runtime.
2. Build the docker image from the dockerfile, tag it appropriately.
3. Run the docker container, accounting for ports, Jupyter notebook tokens, volume mounting, etc.
  - to mount a volume on Windows: `-v 'C:/Users/ZacHeacker/...path/...to/...directory:/data'`
  - to mount a volume on Linux: `-v /...path/...to/...directory:/data`
4. Install Atom and Hydrogen locally.
5. In the Hydrogen settings 'gateway' options, add this code:
```
[{
    "name": "Dockerized Jupyter Kernel",
    "options": {
      "baseUrl": "http://localhost:8888",
      "token": "ztoken"
    }
  }]
  ```
  - This tells Hydrogen where to contact the remote Jupyter kernel; not sure about this secret token thing yet...
6. In Atom, from within a Python script, `ctrl-shift-p` to search for "remote kernel," and connect to the running docker container's Jupyter kernel.
7. `ctrl-enter` executes a single line of code. Check resources for other keyboard shortcuts.

## Instructions for Various Docker Images

### `jupyter/datascience-notebook`
This image works without a custom dockerfile, unless you need to install additional packages. The docker run command for the default image is:
  ```
  docker run -it --rm --name RemoteJupyterDataSci -p 8888:8888 -e JUPYTER_TOKEN=ztoken  jupyter/datascience-notebook
  ```

For a custom image which installs additional packages, the docker command is:
  ```
  docker run -it -p 8888:8888 --init -e JUPYTER_TOKEN=ztoken <image_name>
  ```

### `continuumio/anaconda3`
This image requires a custom docker file. I was able to build the image by editing the `continuumio/Anaconda3` dockerfile, which builds from debian. It required editing the `ENTRYPOINT` and `CMD` arguments.

To build the image, navigate to the directory and run: `docker build -t myanaconda3 .`.

Then `docker run -it -p 8888:8888 -e JUPYTER_TOKEN=ztoken myanaconda3`.

## Atom Packages I Like
- Hydrogen, duh
- language-docker
- language-markdown

## Resources
1. Docker documentation, offline:
  - Run `docker run -it --rm -d -p 4000:4000 docs/docker.github.io:latest`
  - Navigate to http://127.0.0.1:4000
2. Jupyter Docker Stacks: https://jupyter-docker-stacks.readthedocs.io/en/latest/
3. Tini github: https://github.com/krallin/tini/
4. Hydrogen docs: https://nteract.gitbooks.io/hydrogen/
5. Jupyter keyboard shortcuts: https://towardsdatascience.com/jypyter-notebook-shortcuts-bf0101a98330
