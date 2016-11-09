# How to Install Git 2.8.1 on CentOS/RHEL/ScientificLinux 7/6/5

## Step 1 – Install Required Packages

Before installing Git from source code, make sure you have already installed required packages on your system. If not use following command to install required packages.
```
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum install gcc perl-ExtUtils-MakeMaker
```

## Step 2 – Download and Install Git

Download latest Git source code from kernel git or simply use following command to download Git 2.8.1.
```
cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-2.8.1.tar.gz
tar xzf git-2.8.1.tar.gz
```

After downloading and extracting Git source code, Use following command to compile source code.
```
cd git-2.8.1
make prefix=/usr/local/git all
make prefix=/usr/local/git install
```

## Step 3 – Setup Environment

After installation of git client. Now you must need to set binary in system environment. So edit /etc/bashrc file and add below content to it
```
export PATH=$PATH:/usr/local/git/bin
```

Now execute below command to reload configuration in current environment.
```
source /etc/bashrc
```

After completing above steps. Let’s use following command to check current git version.
```
git --version
```

git version 2.8.1
