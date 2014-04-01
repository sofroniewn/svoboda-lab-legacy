#!/bin/bash

rm -rf compiled
mkdir compiled
cd compiled
/usr/local/matlab-2010a/bin/mcc -R -singleCompThread -C -m /groups/freeman/home/freemanj11/code/wgnr/imaging/image_registration/accessory_fns/register_cluster_directory.m -a /groups/freeman/home/freemanj11/code/wgnr/imaging/
./register_cluster_directory
cd ..
echo "registration successfully compiled for cluster"
chmod -R 777 compiled