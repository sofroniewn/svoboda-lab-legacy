import os
import argparse
import glob
import re

from thunder.regression.util import RegressionModel
from thunder.util.load import load
from thunder.util.save import save
from thunder.sigprocessing.stats import stats
from thunder.sigprocessing.localcorr import localcorr
from thunder.regression.tuning import tuning
from thunder.regression.regress import regress

from pyspark import SparkContext

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="perform multiple computations")
    parser.add_argument("master", type=str)
    parser.add_argument("datafolder", type=str)
    parser.add_argument("imagename", type=str)
    parser.add_argument("--preprocess", choices=("raw", "dff", "dff-highpass", "sub"), default="raw", required=False)
    parser.add_argument("--neighbourhood", type=int, default=5, required=False)
    parser.add_argument("--regressmode", choices=("linear", "bilinear"), default="linear", required=False, help="form of regression")
    parser.add_argument("--tuningmode", choices=("circular", "gaussian"), default="gaussian", required=False, help="form of tuning curve")
    parser.add_argument("--basename", type=str, default="-", required=False)
    parser.add_argument("--stim", type=str, default="-", required=False)

    args = parser.parse_args()

    sc = SparkContext(args.master, "myscript")

    if args.master != "local":
        egg = glob.glob(os.path.join(os.environ['THUNDER_EGG'], "*.egg"))
        sc.addPyFile(egg[0])
    
    # load data file
    datafile = os.path.join(args.datafolder, args.imagename)
    outputdir = os.path.join(args.datafolder,"spark")
    data = load(sc, datafile, args.preprocess, 4)
    
    # drop key
    data = data.map(lambda (k, v): (k[0:3], v))
    data.cache()

    # compute mean map
    vals = stats(data,"mean")
    save(vals,outputdir,"mean_vals","matlab")

    # compute local cor
    if args.neighbourhood != 0:
        cor = localcorr(data,args.neighbourhood)
        save(cor,outputdir,"local_corr","matlab")

    # if stim argument is not default
    if args.stim != '-':
        # parse into different stim names
        p = re.compile('-')
        stims = p.split(args.stim)

        # compute regression
        for i in range(len(stims)):
            modelfile = os.path.join(args.datafolder, args.basename + stims[i])
            stats, betas = regress(data, modelfile, args.regressmode)
            tune = tuning(betas,modelfile, args.tuningmode)
            out_name = "stats_" + stims[i]
            save(stats, outputdir, out_name, "matlab")
            out_name = "tune_" + stims[i]
            save(tune, outputdir, out_name, "matlab")




