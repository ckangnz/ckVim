# Installing MongoDB on Mac

```bash
# Install using Homebrew
  brew install mongodb

# Create a directory to store data
  sudo mkdir /data/db
  chown -R `id -un` /data/db

# Start Database Server :
# if you created data directory in /data/db
  mongod
# if you created data directory in custom location
  mongod --dbpath ~/custon-location-to-data
# to quit
  ctrl + c

# Mongo Shell (must have server running)
  mongo
  quit()
```

# GUI Version of MongoDB (Robo-3T)

```bash
# Install using Brew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null
  brew cask install robo-3t

# Open Robo Mongo
# Connect with default localhost:27017 with any name
```

# MongoDB Basics

```bash
#Run server then:
mongo

> db.collectionname.insert({name:"Chris"})
> db.collectionname.find()
> db.getCollection('collectionname').find()
```
