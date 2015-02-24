import os
import re
import pandas
import datetime
import pylab as pl
mdpath = os.path.abspath(os.path.join(os.getcwd(), '..', 'Thesis'))
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
for line in lines:
    date = re.search('[0-9]+-[0-9]+-[0-9]+', line)
    if date is not None:
        current_date = datetime.datetime.strptime(date.group(), '%m-%d-%Y')
    words = re.search('Words in text: ([0-9]+)', line)
    if words is not None:
        current_words = float(words.groups()[0])
    if (current_words is not None) and (current_date is not None):
        data[current_date.date()] = {'words' : current_words}
        cutrrent_data, current_words = None, None

df = pandas.DataFrame.from_dict(data)
df.T['words'].plot(
    marker='o', linestyle='', color='k',
)
pl.xlabel('Date')
pl.ylabel('Word count')
pl.xticks(rotation=20)
pl.savefig(os.path.join(mdpath, 'metedata.pdf'))




