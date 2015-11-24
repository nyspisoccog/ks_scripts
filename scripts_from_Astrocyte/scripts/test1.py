from subprocess import Popen, PIPE, call, check_output
import os

def source(script, update=1):
    pipe = Popen(". %s; env" % script, stdout=PIPE, shell=True)
    data = pipe.communicate()[0]
    env = dict((line.split("=", 1) for line in data.splitlines()))
    if update:
        os.environ.update(env)
    return env

env = {}
env.update(os.environ)
env.update(source('~/scripts/mySetUpFreeSurfer.sh'))
env.update(source('/usr/local/freesurfer/FreeSurferEnv.sh'))

print env['TEST_ENV_VAR']
check_output('echo $TEST_ENV_VAR', shell=True, env=env)
#check_output('echo $TEST_ENV_VAR/test', shell=True, env=env)



cmd = 'mkdir $TEST_ENV_VAR/test'
check_output(cmd, shell=True, env=env)
call(cmd, shell=True)
