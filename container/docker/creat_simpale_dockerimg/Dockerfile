# using official python iamge as the basic image
FROM python:3.8-slim
# set workdir
WORKDIR /app
# copy current content to work dir
COPY . /app
# install dependency
RUN pip install --no-cache-dir -r requirements.txt

# expose the app port
EXPOSE 5000
# run app
CMD ["python", "flask_web.py"]

# please see how to install docker under the container dir 4_installDockerEngine.sh
