sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org (if 32-bit sudo apt-get install -y mongodb)

(create data folder first /data/db)
sudo service mongod start (or mongod --dbpath /home/*** --port 12345)