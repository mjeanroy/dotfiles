# Bootstrap a new environment with main softwate

NODE_VERSION=8
MVN_VERSION=3.5.3

echo "[info] Update system"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

echo ""
echo "[info] Installing main software and tools"
sudo apt-get install -y \
  vim \
  curl \
  wget \
  git \
  xclip \
  netcat \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  filezilla \
  chromium-browser \
  terminator

echo ""
echo "[info] Installing keepassx"
sudo apt-get -y install keepassx

echo ""
echo "[info] Installing docker and docker-compose"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt-get -y update && sudo apt-get -y install docker-ce

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo ""
echo "[info] Installing openjdk8"
sudo apt-get install -y openjdk-8-jdk

echo ""
echo "[info] Installing NVM with Node 8"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install $NODE_VERSION

echo ""
echo "[info] Installing maven"

sudo rm -rf /opt/apache-maven-$MVN_VERSION > /dev/null 2>&1
sudo rm /opt/maven > /dev/null 2>&1

cd /tmp && wget http://apache.crihan.fr/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
sleep 3
cd /opt && sudo mv /tmp/apache-maven-$MVN_VERSION-bin.tar.gz . && sudo tar xvfz apache-maven-$MVN_VERSION-bin.tar.gz
sudo rm /opt/apache-maven-$MVN_VERSION-bin.tar.gz
sudo ln -s /opt/apache-maven-$MVN_VERSION maven

echo ""
echo "[info] Installing sublime text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get -y install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get -y update
sudo apt-get -y install sublime-text

