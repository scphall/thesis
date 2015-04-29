import os
import re
import pandas
import datetime
import pylab as pl
mdpath = 'Thesis'
mdfile = os.path.join(mdpath, 'metadata')

lines = []
with open(mdfile) as f:
    line = f.readline()
    lines.append(line)
    while line:
        lines.append(line)
        line = f.readline()

data = {}
current_date = None
current_words = None
current_figs = None
for line in lines:
    date = re.search('[0-9]+-[0-9]+-[0-9]+', line)
    if date is not None:
        current_date = datetime.datetime.strptime(date.group(), '%m-%d-%Y')
    words = re.search('Words in text: ([0-9]+)', line)
    if words is not None:
        current_words = float(words.groups()[0])
    figs = re.search('Number of floats/tables/figures: ([0-9]+)', line)
    if figs is not None:
        current_figs = float(figs.groups()[0])
    if (current_words is not None) and \
       (current_date is not None) and \
       (current_figs is not None):
        data[current_date.date()] = {
            'words' : current_words,
            'figs' : current_figs,
        }
        cutrrent_data, current_words, current_figs = None, None, None

df = pandas.DataFrame.from_dict(data)

fig, ax1 = pl.subplots()
df.T['words'].plot(
    marker='o', linestyle='-.', color='k',
    #sharex=True,
)
pl.xlabel('Date')
#pl.xticks(rotation=20)
pl.ylabel('Word count')
df.T['figs'].plot(
    marker='s', linestyle=':', color='g',
    alpha=0.5,
    secondary_y=True,
)
pl.ylabel('Float count', color='g')
pl.yticks(color='g')
pl.savefig(os.path.join(mdpath, 'metadata.pdf'))




