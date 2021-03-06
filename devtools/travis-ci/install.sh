MINICONDA=Miniconda3-latest-Linux-x86_64.sh
MINICONDA_MD5=$(curl -s http://repo.continuum.io/miniconda/ | grep -A3 $MINICONDA | sed -n '4p' | sed -n 's/ *<td>\(.*\)<\/td> */\1/p')
wget http://repo.continuum.io/miniconda/$MINICONDA
if [[ $MINICONDA_MD5 != $(md5sum $MINICONDA | cut -d ' ' -f 1) ]]; then
    echo "Miniconda MD5 mismatch"
    exit 1
fi
bash $MINICONDA -b


export PATH=$HOME/miniconda3/bin:$PATH
conda install --yes conda-build jinja2 anaconda-client pip
conda config --add channels http://conda.binstar.org/colli_r
conda config --add channels http://conda.binstar.org/rmcgibbo
conda config --add channels http://conda.binstar.org/omnia


# Install SPARTA+ for NMR chemical shift predicition
MDTRAJ_DIR=`pwd`
mkdir -p $HOME/external
cd $HOME/external
wget http://mdtraj.org/travis-ci-cache/sparta+.tar.Z
REFERENCE_MD5="d4293336254f5696221db0edcc57cfed"
RECEIVED_MD5=$(md5sum sparta+.tar.Z | cut -d " " -f 1)
if [ $REFERENCE_MD5 != $RECEIVED_MD5 ]; then
    echo "sparta+.tar.Z md5 mismatch"
    exit 1
fi

tar -xzf sparta+.tar.Z
cd SPARTA+
csh ./install.com
export SPARTAP_DIR=`pwd`
export SPARTA_DIR=`pwd`
export PATH=`pwd`/bin:$PATH
# go back to the original directory we were in
cd $MDTRAJ_DIR


# Install ppm for NMR chemical shift predicition
MDTRAJ_DIR=`pwd`
mkdir -p $HOME/external
cd $HOME/external
wget http://mdtraj.org/travis-ci-cache/ppm_linux_64.exe
chmod a+x ppm_linux_64.exe
REFERENCE_MD5="f3cb5681bd2769cdcfc77fe17c563ee4"
RECEIVED_MD5=$(md5sum ppm_linux_64.exe | cut -d " " -f 1)
if [ $REFERENCE_MD5 != $RECEIVED_MD5 ]; then
    echo "ppm_linux_64.exe md5 mismatch"
    exit 1
fi

export PATH=`pwd`:$PATH
# go back to the original directory we were in
cd $MDTRAJ_DIR
