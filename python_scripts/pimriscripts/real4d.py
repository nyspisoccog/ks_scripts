__author__ = 'katie'


from nipype.interfaces.nipy.preprocess import FmriRealign4d
import os

pth = "/media/truecrypt1/SocCog/tmp1/run1L2"

infile = os.path.join(pth, '4D.nii')


realigner = FmriRealign4d()
realigner.inputs.in_file = [infile]
realigner.inputs.tr = 2.2
realigner.inputs.slice_order = range(0, 34, 2) + range(1, 35, 2)
realigner.inputs.time_interp = True
res = realigner.run()