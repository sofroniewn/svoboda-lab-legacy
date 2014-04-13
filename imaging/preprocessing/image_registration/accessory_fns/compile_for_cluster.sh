#!/bin/bash

cd ../../../..
rm -rf compiled
mkdir compiled
cd compiled
/usr/local/matlab-2010a/bin/mcc -R -singleCompThread -C -m /groups/freeman/home/freemanj11/code/wgnr/imaging/preprocessing/image_registration/accessory_fns/register_cluster_directory.m -a /groups/freeman/home/freemanj11/code/wgnr/imaging/preprocessing/
./register_cluster_directory
/usr/local/matlab-2010a/bin/mcc -R -singleCompThread -C -m /groups/freeman/home/freemanj11/code/wgnr/imaging/preprocessing/image_registration/accessory_fns/save_text_cluster.m -a /groups/freeman/home/freemanj11/code/wgnr/imaging/preprocessing/
./save_text_cluster
cd ..
echo "code successfully compiled for cluster"
chmod -R 777 compiled