#!/bin/bash

 
# install some necessary tools & libs
echo "install some necessary tools & libs"
yum groupinstall "Development tools" -y
yum install openssl-devel zlib-devel ncurses-devel bzip2-devel readline-devel -y 
yum install libtool-ltdl-devel sqlite-devel tk-devel tcl-devel -y
sleep 5
 
# download and install python
version='2.7.13'
python_url="https://www.python.org/ftp/python/$version/Python-${version}.tgz"
 
# check current python version
echo "before installation, your python version is: $(python -V &2>1)"
python -V 2>&1 | grep "$version"
if [ $? -eq 0 ]; then
  echo "current version is the same as this installation."
  echo "Quit as no need to install."
  exit 0
fi
 
echo "download/build/install your python"
cd /tmp
wget $python_url
tar -zxf Python-${version}.tgz
cd Python-${version}
./configure --prefix=/usr/local/python2.7
make && make install
ln -sf /usr/local/python2.7/bin/python2.7 /usr/bin/python
sleep 5
 
echo "check your installed python"
python -V 2>&1 | grep "$version"
if [ $? -ne 0 ]; then
  echo "python -V is not your installed version"
  /usr/local/bin/python -V 2>&1 | grep "$version"
  if [ $? -ne 0 ]; then
    echo "installation failed. use '/usr/local/bin/python -V' to have a check"
  fi
  exit 1
fi
sleep 5
#update yum
sed -i 's/python/python2.6/g' /usr/bin/yum

#install setuptools
cd /tmp
wget https://pypi.python.org/packages/6c/54/f7e9cea6897636a04e74c3954f0d8335cc38f7d01e27eec98026b049a300/setuptools-38.5.1.zip#md5=1705ae74b04d1637f604c336bb565720
unzip setuptools-38.5.1.zip
cd setuptools-38.5.1
python setup.py install 

#pip install....
echo "install pip for the new python"
cd /tmp
wget https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz#md5=35f01da33009719497f01a4ba69d63c9
tar -xf pip-9.0.1.tar.gz
cd pip-9.0.1
python setup.py install
ln -s /usr/local/python2.7/bin/pip /usr/bin/pip

echo "Done"
# check pip version
pip -V
 
echo "Finished. Well done!"

