function vals = valsReg_spark(reg_data,num_bins)

vals = quantile(reg_data,num_bins);

