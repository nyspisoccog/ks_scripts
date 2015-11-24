nofilt_diffs = zeros(1,1000);
filt_diffs = zeros(1,1000);

for j = 1:1000
    
    %initialize vector with ones where there are events (4s long), zeros
    %for fixation (2s long)
    reg = [ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1);  ...
        ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ...
        ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ...
        ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ...
        ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1); ones(4, 1); zeros(2, 1);];
    
    
    %initialize cond vector with zeros for irrelevant events, 1s for
    %relevant
    cond = zeros(1,20);
    relcnt = 0;
    irrcnt = 0;
    
    for i = 1:20 
        a = randi([0, 1]);
        if a == 0
            irrcnt = irrcnt + 1;
        else
            relcnt = relcnt + 1;
        end
        if irrcnt > 10
            a = 1;
        elseif relcnt > 10
            a = 0;
        end
        cond(i) = a;
    end
    
    %establish values for regressors.  start with mean 3, sd .5
    a = .5;
    b = 3;

    rel = a.*randn(10,1) + b;
    irr = a.*randn(10,1) + b;
    
    %add an increasing trend to relevant regressors

    for i = 1:numel(rel)
        rel(i) = rel(i) + (i-1)*.4;
    end
    
    %assign irr and rel regressors to a single vector in the order
    %established by cond
    
    dat = cond;

    for i = 1:numel(cond)
        if dat(i) == 0
            dat(i) = irr(1);
            irr = irr(2:end);
        else
            dat(i) = rel(1);
            rel = rel(2:end);
        end
    end


    %assign regressor values from dat to reg 4 at a time (same regressor value
    %for all four seconds of event)

    for i = 1:numel(reg)
        reg(i) = reg(i)*dat(int8((i-3.5)/6)+ 1);
    end
    
    %convolve bold function with reg
    xBF.dt = 1.000;
    xBF.name = 'hrf';

    bf = spm_get_bf(xBF);
    U.u = reg;
    U.name = {'reg'};
    convreg = spm_Volterra(U, bf.bf);
    
   %collect condition specific values of the convolved regressor
    irrhrf = [];
    relhrf = [];

    for i=1:numel(cond)
        if cond(i) == 0
            irrhrf = vertcat(irrhrf, convreg((i-1)*6+1:(i-1)*6+4));
        else
            relhrf = vertcat(relhrf, convreg((i-1)*6+1:(i-1)*6+4));
        end
    end
    
    %construct a vector with a predictor linearly varying in time
    pred = [1:40];
    pred = pred - mean(pred);
    pred = transpose(pred);
    
    %fit convolved regressors to the time varying predictor, within condition
    irrmdl = fitlm(pred, irrhrf);
    relmdl = fitlm(pred, relhrf);
    
    %test for the difference of the averages
    irrmean = mean(irrhrf);
    relmean = mean(relhrf);
    ttest = ttest2(irrhrf, relhrf);
    
    %when running this script as a simulation with lots of iterations,
    %collect the differences between conditions
    nofilt_diffs(j) = relmean-irrmean;
    
    %high pass filter
    K.RT = 1.0;
    K.row = 1:120; % 120 corresponds to the length of convreg
    K.HParam = 800;%this is the parameter that determines the period of the filter

    nK = spm_filter(K);
    Y = spm_filter(nK, convreg);
    
    
    %collect the regressions/ttests on the filtered data
    irrflt = [];
    relflt = [];

    for i=1:numel(cond)
        if cond(i) == 0
            irrflt = vertcat(irrflt, Y((i-1)*6+1:(i-1)*6+4));
        else
            relflt = vertcat(relflt, Y((i-1)*6+1:(i-1)*6+4));
        end
    end
    irrmdlflt = fitlm(pred, irrflt);
    relmdlflt = fitlm(pred, relflt);
    irrmeanflt = mean(irrflt);
    relmeanflt = mean(relflt);
    tfilt = ttest2(irrflt, relflt);
    filt_diffs(j) = relmeanflt-irrmeanflt;

end

filt_stats = [mean(filt_diffs) std(filt_diffs) var(filt_diffs)]

nofilt_stats = [mean(nofilt_diffs) std(nofilt_diffs) var(nofilt_diffs)]