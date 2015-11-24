import estimate_cluster


subs = ['7408', '7412', '7414']

mat_file_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate/mat_files/lrn'

script_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate'

log_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate/logdir'

estimate_cluster.job_spec(script_dir, subs, mat_file_dir, log_dir)
estimate_cluster.submit_job(script_dir)
