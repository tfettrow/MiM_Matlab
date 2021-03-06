% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

create_model_and_estimate=1;
task_folder = '05_MotorImagery';
% task_folder = '06_Nback';
% correction_type = 'voxel_wise';
correction_type = 'TFCE';
nonparametric = 1;

group_one_subject_codes =  {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024'};
% group_one_subject_codes =  {'1002','1004','1007','1009','1010'};
% group_two_subject_codes =  {'1011','1013','1020','1022','1027','1024'};

% group_one_subject_codes =  {'2021','2015','2002','2018','2017','2012','2025','2020','2026'};
% group_two_subject_codes =  {'2023','2022','2007','2013','2008','2033','2034','2037','2052','2042'};
group_two_subject_codes =  {'2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042'};

% group_one_subject_codes = {'1002', '1004', '1010', '1011','1013'}; % need to figure out how to pass cell from shell
% group_two_subject_codes =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

if nonparametric
    level2_results_dir = fullfile(data_path, 'Results_fmri_3FacSWENP_ALL_TFCE', 'MRI_files', task_folder);
else
    level2_results_dir = fullfile(data_path, 'Results_fmri_3FacSWE', 'MRI_files', task_folder);
end

matlabbatch{1}.spm.tools.swe.smodel.dir = {level2_results_dir}; % results directory

% seems a bit redundant but lets go with it for now
if strcmp(task_folder, '05_MotorImagery')
    scans = {};
    group_one_conditions=[];
    number_of_subjects = 1;
    for this_subject_index = 1 : length(group_one_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        Flat_greaterthan_Rest_contrast_index = find(contains(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(contains(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index = find(contains(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(contains(contrasts, 'high>Rest'));
        
        this_subject_conn_images = dir(char(fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'con*')));
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
        this_subject_condition_list = {fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)};
        
        this_subect_condition = 1;
        for this_condition = number_of_subjects*number_of_conditions - 3 : number_of_subjects*number_of_conditions
            scans{this_condition, 1} = this_subject_condition_list{this_subect_condition};
            this_subect_condition = this_subect_condition+1;
        end
         number_of_subjects = number_of_subjects + 1;
    end
    for this_subject_index = 1 : length(group_two_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'subject_info.csv');
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        Flat_greaterthan_Rest_contrast_index = find(contains(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(contains(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index = find(contains(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(contains(contrasts, 'high>Rest'));
        
        this_subject_conn_images = dir(char(fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'con*')));
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
       
        this_subject_condition_list = {fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)};
        
        this_subect_condition = 1;
        for this_condition = number_of_subjects*number_of_conditions - 3 : number_of_subjects*number_of_conditions
            scans{this_condition, 1} = this_subject_condition_list{this_subect_condition};
            this_subect_condition = this_subect_condition+1;
        end
         number_of_subjects = number_of_subjects + 1;
    end
elseif strcmp(task_folder, '06_Nback')
    scans = {};
    group_one_conditions=[];
    number_of_subjects = 1;
    for this_subject_index = 1 : length(group_one_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        zero_greaterthan_Rest_contrast_index =  find(strcmp(contrasts, 'zero>Rest'));
        %          longZero_greaterthan_Rest_contrast_index = find(contains(contrasts, 'long_zero>Rest'));
        one_greaterthan_Rest_contrast_index = find(strcmp(contrasts,'one>Rest'));
        %          longOne_greaterthan_Rest_index = find(contains(contrasts, 'long_one>Rest'));
        two_greaterthan_Rest_index =  find(strcmp(contrasts, 'two>Rest'));
        %          longTwo_greaterthan_Rest_index = find(contains(contrasts, 'long_two>Rest'));
        three_greaterthan_Rest_index = find(strcmp(contrasts, 'three>Rest'));
        %          longThree_greaterthan_Rest_index = find(contains(contrasts, 'long_three>Rest'));
        
        number_of_conditions = length([zero_greaterthan_Rest_contrast_index one_greaterthan_Rest_contrast_index two_greaterthan_Rest_index three_greaterthan_Rest_index]);
        this_subject_conn_images = dir(char(fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'con*')));
        
        this_subject_condition_list = {fullfile(this_subject_conn_images(zero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(zero_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(one_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(one_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(two_greaterthan_Rest_index).folder, this_subject_conn_images(two_greaterthan_Rest_index).name); ...
            fullfile(this_subject_conn_images(three_greaterthan_Rest_index).folder, this_subject_conn_images(three_greaterthan_Rest_index).name)};
   
        this_subect_condition = 1;
        for this_condition = number_of_subjects*number_of_conditions - 3 : number_of_subjects*number_of_conditions
            scans{this_condition, 1} = this_subject_condition_list{this_subect_condition};
            this_subect_condition = this_subect_condition+1;
        end
        number_of_subjects = number_of_subjects + 1;
    end
     for this_subject_index = 1 : length(group_two_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'subject_info.csv');
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        
        zero_greaterthan_Rest_contrast_index =  find(strcmp(contrasts, 'zero>Rest'));
        %          longZero_greaterthan_Rest_contrast_index = find(contains(contrasts, 'long_zero>Rest'));
        one_greaterthan_Rest_contrast_index = find(strcmp(contrasts,'one>Rest'));
        %          longOne_greaterthan_Rest_index = find(contains(contrasts, 'long_one>Rest'));
        two_greaterthan_Rest_index =  find(strcmp(contrasts, 'two>Rest'));
        %          longTwo_greaterthan_Rest_index = find(contains(contrasts, 'long_two>Rest'));
        three_greaterthan_Rest_index = find(strcmp(contrasts, 'three>Rest'));
        %          longThree_greaterthan_Rest_index = find(contains(contrasts, 'long_three>Rest'));
        
        number_of_conditions = length([zero_greaterthan_Rest_contrast_index one_greaterthan_Rest_contrast_index two_greaterthan_Rest_index three_greaterthan_Rest_index]);
        this_subject_conn_images = dir(char(fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'con*')));
        
        this_subject_condition_list = {fullfile(this_subject_conn_images(zero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(zero_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(one_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(one_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(two_greaterthan_Rest_index).folder, this_subject_conn_images(two_greaterthan_Rest_index).name); ...
            fullfile(this_subject_conn_images(three_greaterthan_Rest_index).folder, this_subject_conn_images(three_greaterthan_Rest_index).name)};
        this_subect_condition = 1;
        for this_condition = number_of_subjects*number_of_conditions - 3 : number_of_subjects*number_of_conditions
            scans{this_condition, 1} = this_subject_condition_list{this_subect_condition};
            this_subect_condition = this_subect_condition+1;
        end
         number_of_subjects = number_of_subjects + 1;
    end
else
    disp('task folder specified does not exist!!')
end


matlabbatch{1}.spm.tools.swe.smodel.scans = scans; % con images
matlabbatch{1}.spm.tools.swe.smodel.ciftiAdditionalInfo.ciftiGeomFile = struct('brainStructureLabel', {}, 'geomFile', {}, 'areaFile', {});
matlabbatch{1}.spm.tools.swe.smodel.ciftiAdditionalInfo.volRoiConstraint = 1; 
matlabbatch{1}.spm.tools.swe.smodel.type.modified.groups = [ones(1,length(group_one_subject_codes)*length(this_subject_condition_list)), ones(1, length(group_two_subject_codes)*length(this_subject_condition_list)) * 2 ]; % vector assigning groups
matlabbatch{1}.spm.tools.swe.smodel.type.modified.visits = kron(ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)),(1:4)); % vector assigning conditions

matlabbatch{1}.spm.tools.swe.smodel.type.modified.ss = 4;
matlabbatch{1}.spm.tools.swe.smodel.type.modified.dof_mo = 3;

matlabbatch{1}.spm.tools.swe.smodel.subjects = kron(1:length(group_one_subject_codes) + length(group_two_subject_codes), ones(1,length(this_subject_condition_list))); %kron(ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)),(1:4));

if strcmp(task_folder, '05_MotorImagery')
    
    matlabbatch{1}.spm.tools.swe.smodel.cov(1).c = repmat([1 0 0 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
%     matlabbatch{1}.spm.tools.swe.smodel.cov(1).c = kron([1 0 0 0], ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(1).cname = 'flat';
    matlabbatch{1}.spm.tools.swe.smodel.cov(2).c = repmat([0 1 0 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
    matlabbatch{1}.spm.tools.swe.smodel.cov(2).cname = 'low';
    matlabbatch{1}.spm.tools.swe.smodel.cov(3).c = repmat([0 0 1 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
    matlabbatch{1}.spm.tools.swe.smodel.cov(3).cname = 'medium';
    matlabbatch{1}.spm.tools.swe.smodel.cov(4).c = repmat([0 0 0 1], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
    matlabbatch{1}.spm.tools.swe.smodel.cov(4).cname = 'high';
    % matlabbatch{1}.spm.tools.swe.smodel.cov(5).c = kron([ones(1,length(group_one_subject_codes)), zeros(1,length(group_two_subject_codes)) ], [1 1 1 1] );
    % matlabbatch{1}.spm.tools.swe.smodel.cov(5).cname = 'young';
    % matlabbatch{1}.spm.tools.swe.smodel.cov(6).c = kron([zeros(1,length(group_one_subject_codes)), ones(1,length(group_two_subject_codes)) ], [1 1 1 1] );
    % matlabbatch{1}.spm.tools.swe.smodel.cov(6).cname = 'old';
    matlabbatch{1}.spm.tools.swe.smodel.cov(5).c = kron( [1 1 1 1],ones(1,length(group_one_subject_codes)+length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(5).cname = 'global';

elseif strcmp(task_folder, '06_Nback')
    matlabbatch{1}.spm.tools.swe.smodel.cov(1).c = repmat([1 0 0 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
%     matlabbatch{1}.spm.tools.swe.smodel.cov(1).c = kron([1 0 0 0], ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(1).cname = 'zero';
    matlabbatch{1}.spm.tools.swe.smodel.cov(2).c = repmat([0 1 0 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
% matlabbatch{1}.spm.tools.swe.smodel.cov(2).c = kron([0 1 0 0], ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(2).cname = 'one';
    matlabbatch{1}.spm.tools.swe.smodel.cov(3).c = repmat([0 0 1 0], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
% matlabbatch{1}.spm.tools.swe.smodel.cov(3).c = kron([0 0 1 0], ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(3).cname = 'two';
    matlabbatch{1}.spm.tools.swe.smodel.cov(4).c = repmat([0 0 0 1], 1, length(group_one_subject_codes) + length(group_two_subject_codes));
% matlabbatch{1}.spm.tools.swe.smodel.cov(4).c = kron([0 0 0 1], ones(1,length(group_one_subject_codes) + length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(4).cname = 'three';
    % matlabbatch{1}.spm.tools.swe.smodel.cov(5).c = kron([ones(1,length(group_one_subject_codes)), zeros(1,length(group_two_subject_codes)) ], [1 1 1 1] );
    % matlabbatch{1}.spm.tools.swe.smodel.cov(5).cname = 'young';
    % matlabbatch{1}.spm.tools.swe.smodel.cov(6).c = kron([zeros(1,length(group_one_subject_codes)), ones(1,length(group_two_subject_codes)) ], [1 1 1 1] );
    % matlabbatch{1}.spm.tools.swe.smodel.cov(6).cname = 'old';
    matlabbatch{1}.spm.tools.swe.smodel.cov(5).c = kron( [1 1 1 1],ones(1,length(group_one_subject_codes)+length(group_two_subject_codes)));
    matlabbatch{1}.spm.tools.swe.smodel.cov(5).cname = 'global';
end

matlabbatch{1}.spm.tools.swe.smodel.multi_cov = struct('files', {});
matlabbatch{1}.spm.tools.swe.smodel.masking.tm.tm_none = 1;
matlabbatch{1}.spm.tools.swe.smodel.masking.im = 1;
matlabbatch{1}.spm.tools.swe.smodel.masking.em = {''};
% %
if ~nonparametric
    % parametric
    matlabbatch{1}.spm.tools.swe.smodel.WB.WB_no = 0;
else
    % non-parametric
    matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_ss = 4;
    matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_nB = 999; %default is 999
    matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_SwE = 0;
    matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_stat.WB_T.WB_T_con = [-3 -1 1 3 0];
    if strcmp(correction_type, 'voxel_wise')
        matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_infType.WB_voxelwise = 0;
    elseif strcmp(correction_type, 'TFCE')
        matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_infType.WB_TFCE.WB_TFCE_E = 0.5;
        matlabbatch{1}.spm.tools.swe.smodel.WB.WB_yes.WB_infType.WB_TFCE.WB_TFCE_H = 2;
    end
    % %
end
matlabbatch{1}.spm.tools.swe.smodel.globalc.g_omit = 1;
matlabbatch{1}.spm.tools.swe.smodel.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.tools.swe.smodel.globalm.glonorm = 1;

if create_model_and_estimate
    if exist(fullfile(level2_results_dir,'SwE.mat'),'file')
        rmdir(level2_results_dir, 's')
    end    
    mkdir(level2_results_dir)
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

matlabbatch{1}.spm.tools.swe.rmodel.des = {strcat(level2_results_dir,filesep,'SwE.mat')};
spm_jobman('run',matlabbatch);
clear matlabbatch
 
% matlabbatch{1}.spm.tools.swe.results.dis = {strcat(level2_results_dir,filesep,'SwE.mat')};
% spm_jobman('run',matlabbatch);
% clear matlabbatch
