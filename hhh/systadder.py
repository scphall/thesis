from math import sqrt
from copy import deepcopy
import pandas

def quad(*args):
    return sqrt(sum([x**2 for x in args]))

def update(name, new, old):
    new[name] = old[name]
    return

def total(new):
    ls = [[], [], [], [], []]
    for key, item in new.iteritems():
        for i in range(5):
            ls[i].append(item[i])
    totals = [quad(*x) for x in ls]
    return totals

def add(name, names, new, old):
    ls = [[], [], [], [], []]
    for n in names:
        for i in range(5):
            ls[i].append(old[n][i])
        if n in new:
            new.pop(n)
    new[name] = [quad(*x) for x in ls]
    return


systs = {
    'Norm'                  :   [0.288 ,   0.096 ,   0.094 ,   0.075 ,   0.004],
    'Tracking'              :   [0.080 ,   0.020 ,   0.024 ,   0.012 ,   0.000],
    'Reweighting'           :   [0.106 ,   0.006 ,   0.034 ,   0.006 ,   0.000],
    'PID'                   :   [0.060 ,   0.057 ,   0.041 ,   0.044 ,   0.002],
    'muon'                  :   [0.055 ,   0.020 ,   0.018 ,   0.010 ,   0.000],
    'sig'                   :   [0.138 ,   0.052 ,   0.052 ,   0.039 ,   0.002],
    'bkg'                   :   [0.154 ,   0.038 ,   0.052 ,   0.093 ,   0.003],
    'q2'                    :   [0.087 ,   0.047 ,   0.027 ,   0.094 ,   0.002],
    'Kpipi'                 :   [0.175 ,   0.009 ,   0.010 ,   0.061 ,   0.004],
    'thetakone'             :   [0.110 ,   0.036 ,   0.062 ,   0.003 ,   0.001],
    'rel'                   :   [0.014 ,   0.005 ,   0.003 ,   0.003 ,   0.000],
    'Peaking'               :   [0.000 ,   0.000 ,   0.126 ,   0.000 ,   0.000],
    'Trigger'               :   [0.152 ,   0.052 ,   0.042 ,   0.011 ,   0.000],
    'Total' : [ 0.473 , 0.154 , 0.201 , 0.175 , 0.007 ],
}

new = deepcopy(systs)

print pandas.DataFrame.from_dict(new).T.to_latex()
print total(new)
print '\n\n'

add('Corrections', ['Tracking', 'Trigger', 'PID', 'muon', 'Reweighting'], new, systs)
df = pandas.DataFrame.from_dict(new).T
print df.to_latex(
    float_format=lambda x: '{:.3f}'.format(x),
)
print total(new)

#print new
#
#print total(new)







