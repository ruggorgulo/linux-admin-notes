# How To Install The Latest Git On Ubuntu 14.04

1. Add repository
  ```
  sudo add-apt-repository ppa:git-core/ppa
  ```

  If this command fails with message
  ```
  Cannot add PPA: 
  '"Error reading https://launchpad.net/api/1.0/~git-core/+archive/ppa: 
  (7, 'Failed to connect to launchpad.net port 443: Connection refused')"'.
  ```
  
  then this PPA can be added to your system manually by copying
  the lines below and adding them to your system's software sources. 

  ```
  deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main 
  deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main
  ```
  
1. Install git
  ```
  sudo apt-get update
  sudo apt-get install git
  ```
  
1. Check the version of the installed Git:
  ```
  git --version
  ```

It's not always necessary to remove the existing Git before upgrading it,
but if you run into any problems, do the following and then repeat the steps mentioned above:
```
sudo apt-get remove git
```

# Launchpad

https://launchpad.net/~git-core/+archive/ubuntu/ppa
