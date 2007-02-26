#!/bin/sh

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

# Build JavaScript::SpiderMonkey
cd $build_dir
export PERLLIB=$log_lib_path
tar xzvf JavaScript-SpiderMonkey*.tar.gz
cd JavaScript-SpiderMonkey*
perl Makefile.PL PREFIX=$prefix
make
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
  echo -e ">>Set your PERLLIB to following path:"
  echo -e "$log_lib_path:$js_lib_path"
fi

