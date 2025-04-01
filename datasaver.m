% Example time series data (replace with your actual data)
reference_position = timeseries(rand(100, 1), (1:100)');
actual_position = timeseries(rand(100, 1), (1:100)');
desired_position = timeseries(rand(100, 1), (1:100)');

% Define the base filename
base_filename = 'position_data';

% Get the current files in the directory that match the base filename pattern
existing_files = dir([base_filename, '_v*.mat']);

% If no files exist, the first version is 'v1'
if isempty(existing_files)
    revision = 1;
else
    % Extract the highest revision number and increment it
    revisions = cellfun(@(x) sscanf(x, [base_filename, '_v%d.mat']), {existing_files.name});
    revision = max(revisions) + 1;
end

% Construct the new filename with the updated revision
new_filename = sprintf('%s_v%d.mat', base_filename, revision);

% Save the time series data to the .mat file
save(new_filename, 'actual_position', 'desired_forces', 'global_error', 'local_error', 'thruster_input', 'thruster_velocity');

% Display a message confirming the file has been saved
fprintf('Data saved to %s\n', new_filename);
