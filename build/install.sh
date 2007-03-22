#!/bin/sh

# Check for proper arguments.
if [ $# -gt 1 -o $1 = '-h' -o $1 = '--help' ];then
  echo -e "Usage:\t./install.sh [install_path]"
  exit 1
fi

if [ ! -d $1 ];then
  echo "$1 is not a valid directory. Please create directory before starting."
  echo -e "Usage:\t./install.sh [install_path]"
  exit 1
fi

prefix=$1
build_dir=`pwd`

# Build Log::Log4perl
tar xzvf Log-Log4perl*.tar.gz
cd Log-Log4perl*
perl Makefile.PL PREFIX=$prefix
make
make install

# Find our the lib path
if [ ! -z $prefix ];then
  dir=`find $prefix -name "Log4perl.pm" -exec dirname {} \;`
  log_lib_path=`dirname $dir`
fi

# Build js
cd $build_dir
tar xzvf js*.tar.gz
cd js/src
make -f Makefile.ref
# Install libjs.so in $prefix/lib or /usr/lib
libjs_path=`find $PWD -name "libjs.so"`
install -D $libjs_path ${prefix:-/usr}/lib/libjs.so

# Build JavaScript::SpiderMonkey
cd $build_dir
export PERLLIB=$log_lib_path
tar xzvf JavaScript-SpiderMonkey*.tar.gz
cd JavaScript-SpiderMonkey*
perl Makefile.PL PREFIX=$prefix
# LD_RUN_PATH set by MakeMaker is not good. Delete it.
sed -i "/^LD_RUN_PATH[ ]*=.*$/d" Makefile
LD_RUN_PATH=${prefix:-/usr}/lib make
make install


if [ ! -z $prefix ];then
  dir=`find $prefix -name "SpiderMonkey.pm" -exec dirname {} \;`
  js_lib_path=`dirname $dir`
  # Copying pactester and pac_utils.js to $prefix
  cd $build_dir
  sed "s|#\?use lib qw(.*)|use lib qw($log_lib_path $js_lib_path)\;|g" \
                                             ../pactester > $prefix/pactester
  chmod a+rx $prefix/pactester
  cp ../pac_utils.js $prefix
  echo -e "\n\n"
  echo -e "###########################################"
  echo -n ">>PERLLIB="
  echo -e "$log_lib_path:$js_lib_path"
  echo -e "I have set up PERLLIB path in pactester script, so you won't have to"
  echo -e "set it as an environment variable :)\n"
fi

