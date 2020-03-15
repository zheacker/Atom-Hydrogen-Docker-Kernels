# creating a dockerfile with Jupyter
# if using your own Docker image, use the following `FROM` command syntax, substituting your image name

FROM jupyter/minimal-notebook

ADD https://github.com/krallin/tini/release/download/v0.14.0/tini /tini
RUN chmod +x /tini

# if using your own docker image without Jupyter installed:
# RUN pip install jupyter

ENV JUPYTER_TOKEN=my_secret_token
# you can also pass this at runtime

EXPOSE 8888
ENTRYPOINT ["/tini", "--"]

# --no-browser & --port aren't strictly necessary; presented here for clarity
CMD ["jupyter-notebook", "--no-browser", "--port=8888"]

# if running as root, you to explicitly allow this:
# CMD ["jupyter-notebook", "--allow-root", "--no-browser", "--port=8888"]
