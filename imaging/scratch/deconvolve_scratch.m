
  global session_ca

    iRoi = 192;

  iRoi = 24;
dff_trace = session_ca.dff(iRoi,:);
 [n_best P_best V_best C_best] = oopsi_deconv(dff_trace',7.5,0.3,3.6,0.01);

 figure
 hold on
 plot(dff_trace)
  plot(n_best,'r')
        plot(C_best,'g')


			evdetOpts = [];
			evdetOpts.timeUnit = 2;

			dtSec = session.timeSeries.convertTime(mode(diff(session_ca.time)), evdetOpts.timeUnit, 2);
			evdetOpts.tausInDt = ceil(1/dtSec):ceil(5/dtSec); % 1 to 3 sec, tsai wen T1/2 ; tau 1.4 to 4.3 s (will do 1 to 5 s)
			evdetOpts.tRiseInDt = ceil(0.4/dtSec):ceil(0.7/dtSec); % 300-500 ms tsai wen T1/2 ; tau 0.4 to 0.7 sec

			evdetOpts.initThreshSF = 1.4826*0.5;

			evdetOpts.templateFitSF = 1.4826;
			evdetOpts.templateFitSFParam = '';
			evdetOpts.templateFitSFBounds = [];

			evdetOpts.minFitRawCorr = 0;
			evdetOpts.fitResidualNoiseThresh = 1.4826*[0.5 3];

			evdetOpts.enableRun2 = 0;

			nParams.timeUnit = evdetOpts.timeUnit;
			nParams.method = 'sgolay_slide';
			nParams.prefiltSizeInSeconds = 1;
			evdetOpts.nParams = nParams;

			caES = session.timeSeries.getCalciumEventSeriesFromExponentialTemplateS(session_ca.time,session_ca.dff([24 192],:),evdetOpts);


			caES{1}.decayTimeConstants = caES{1}.decayTimeConstants/10;
			dffVec = getDffVectorFromEvents(caES{1}, session_ca.time, evdetOpts.timeUnit);
			
        figure
 hold on
 plot(session_ca.time,session_ca.dff(24,:))
 plot(caES{1}.eventTimes,1,'.r')
 plot(session_ca.time,dffVec,'g')
