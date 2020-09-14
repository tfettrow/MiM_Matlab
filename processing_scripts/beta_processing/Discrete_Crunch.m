
% roi_results figure generation
clear,clc
% close all

%% settings
%select the task 1 = MOTO, 2 = nback
task = 2;
subj = 2;

if task == 1
    task_folder='05_MotorImagery';
    if subj == 1
        subjects = [1002,1004,1010,1011,1013,1009];
    elseif subj == 2
        subjects =  [2002,2007,2008,2012,2013,2015,2018,2020,2021,2022,2023,2025,2026,2033,2034];
    end
elseif task == 2
    task_folder='06_Nback';
    if subj == 1
        subjects = [1002,1004,1010,1011,1013,1009];
    elseif subj == 2
        subjects =  [2002,2007,2008,2012,2013,2015,2018,2020,2021,2022,2023,2025,2026,2033,2034];
    end
end

Results_filename='CRUNCH_discrete.mat';

save_variables = 1;
no_labels = 0;
% data folder path
data_path = 'Z:\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data'; % change this to reflect the share drive path for your PC

%subject_color_matrix = distinguishable_colors(length(subjects));


for sub = 1:length(subjects)
    %create file path for beta values
    subj_results_dir = fullfile(data_path, num2str(subjects(sub)), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(subj_results_dir, strcat(num2str(subjects(sub)),'_fmri_redcap.csv'));
    
    fileID = fopen(this_subject_roiResults_path);
    
    %read the csv file and reshape to have separate headers and values
    data = textscan(fileID,'%s','delimiter',',');
    data = reshape(data{:},length(data{1})/2,2);
    
    for this_beta = 3:length(data)
        split_difficulty = strsplit(data{this_beta,1},'_');%separate difficulty and brain region
        if task == 1
            ordered_conditions{this_beta-2} = split_difficulty{1}; %difficulty level = flat to high
            roi_names{this_beta-2} = strcat(split_difficulty{2},'_',split_difficulty{3}); %brain region name, l-pfc, r-pfc, l-acc, r-acc
        elseif task == 2
            ordered_conditions{this_beta-2} = strcat(split_difficulty{1},'_',split_difficulty{2}); % difficulty = 0 to 3 with long or short ISI
            roi_names{this_beta-2} = strcat(split_difficulty{3},'_',split_difficulty{4}); %brain region name
        end
    end
    
    unique_rois = unique(roi_names); %delete the repeats of the brain region name
    
    this_figure_number = 1;
    figure;
    
    for this_roi_index = 1 : length(unique_rois) %1:4, l-pfc, r-pfc, l-acc, r-acc
        this_roi_indices = find(strcmp(roi_names, unique_rois{this_roi_index})); %find the index of when the current ROI occurs
        
        for k = 1:length(this_roi_indices)
            temp(1,k) = textscan(data{this_roi_indices(k)+2,2},'%f'); %temporary hold the beta value
        end
        beta_values = cell2mat(temp)'; %covert from cell to matrix
        subplot(1, 4, this_figure_number);
        hold on;
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            number_of_levels = 1:4; %difficulty levels (x axis)
            plot(number_of_levels,beta_values,'-or');
            mm = find(max(beta_values)==beta_values); %find the index of max beta value
            if (mm > 3) %ifthe subject has a CRUNCH point
                cr(this_roi_index) = 0; %no CRUNCH point
            else
                cr(this_roi_index) = mm; %CRUNCH point
            end
        elseif any(strcmp(task_folder, '06_Nback'))
            number_of_levels = 1:4;
            number_of_levels2 = 5:8;
            
            plot(number_of_levels,beta_values(1:4),'-or');
            plot(number_of_levels,beta_values(5:8),'-.or');
            mm1 = find(max(beta_values(1:4))==beta_values(1:4)); %CRUNCH for 500 ISI
            if (mm1 > 3)
                cr_500(this_roi_index) = 0;
                
            else
                cr_500(this_roi_index) = mm1;
                
            end
            mm2 = find(max(beta_values(5:8))==beta_values(5:8)); %CRUNCH for 1500 ISI
            if (mm2 > 3)
                cr_1500(this_roi_index) = 0;
            else
                cr_1500(this_roi_index) = mm2;
            end
        end
        hold off;
        xticks(number_of_levels)
        xlim([0 5])
        title(char(unique_rois(this_roi_index)))
        this_figure_number = this_figure_number + 1;
        ylabel('beta value')
        %         clearvars beta_values;
    end
    hold off;
    
    if save_variables
        if any(strcmp(task_folder, '05_MotorImagery'))
            task='MotorImagery';
            save(char(strcat(subj_results_dir,filesep,strcat(num2str(subjects(sub)),'_',task,'_',Results_filename))),'cr*','data','unique_rois');
        elseif any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            save(char(strcat(subj_results_dir,filesep,strcat(num2str(subjects(sub)),'_',task,'_',Results_filename))),'cr*','data','unique_rois');
        end
    end
    fclose(fileID);
    clearvars beta_values cr* data temp ordered_conditions this_beta this_roi_index;
end


