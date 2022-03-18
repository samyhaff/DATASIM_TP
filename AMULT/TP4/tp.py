# import the different functionnalities necessary for your work
import numpy as np
import matplotlib.pyplot as plt
from mne import Epochs, pick_types, events_from_annotations
from mne.io import concatenate_raws, read_raw_edf
from mne.datasets import eegbci
from mne.decoding import CSP
from mne.channels import read_layout
from sklearn.pipeline import Pipeline
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.model_selection import ShuffleSplit, cross_val_score


def load_data(subject):

    """Load data from a subject designated by his identifier.Input:subject: int between 1 and 109Output:raw: mne.Raw, structure containing EEG dataevents: numpy array (n_events, 3)first column:
    date of event in samplesecond column: duration of eventthrid column: event code"""
    assert 1 <= subject <= 109
    # dictionnary to specify the label and code of each event of interest
    event_id = dict(left=0, right=1, hands=2, feet=3)
    # list of dictionnaries to specify the different tasks of interest
    task = [
        dict(T1=event_id["left"], T2=event_id["right"]),
        dict(T1=event_id["hands"], T2=event_id["feet"]),
    ]
    # list of dictionnaries to specify the different runs to load for one subject
    runs = [
        dict(id=4, task=task[0]),
        dict(id=6, task=task[1]),
        dict(id=8, task=task[0]),
        dict(id=10, task=task[1]),
        dict(id=12, task=task[0]),
        dict(id=14, task=task[1]),
    ]
    # load and concatenate the different files from the specified subject
    # download the files if necessary
    raws = list()
    events_list = list()
    for run in runs:
        # localize the file, download it if necessary
        filename = eegbci.load_data(subject, run["id"])
        # load its contain
        raw = read_raw_edf(filename[0], preload=True)
        events, _ = events_from_annotations(raw, event_id=run["task"])
        # accumulate the data
        raws.append(raw)
        events_list.append(events)
        # concatenate all data in two structures : one for EEG, one for the events
        raw, events = concatenate_raws(raws, events_list=events_list)
        # strip channel names of "." characters
        raw.rename_channels(lambda x: x.strip("."))
        # delete annotations
        indices = [x for x in range(len(raw.annotations))]
        indices.reverse()
        for i in indices:
            raw.annotations.delete(i)
        return raw, events


raw_1, events_1 = load_data(1)
raw_2, events_2 = load_data(2)

raw_filtre_1 = raw_1.copy()
raw_filtre_2 = raw_2.copy()

raw_filtre_1 = raw_1.filter(l_freq=8, h_freq=9)

raw_filtre_1.plot()

plt.show()
