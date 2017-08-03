import numpy as np

def levenshtein(source, target):
    if len(source) < len(target):
        return levenshtein(target, source)

    # So now we have len(source) >= len(target).
    if len(target) == 0:
        return len(source)

    # We call tuple() to force strings to be used as sequences
    # ('c', 'a', 't', 's') - numpy uses them as values by default.
    source = np.array(tuple(source))
    target = np.array(tuple(target))

    # We use a dynamic programming algorithm, but with the
    # added optimization that we only need the last two rows
    # of the matrix.
    previous_row = np.arange(target.size + 1)
    for s in source:
        # Insertion (target grows longer than source):
        current_row = previous_row + 1

        # Substitution or matching:
        # Target and source items are aligned, and either
        # are different (cost of 1), or are the same (cost of 0).
        current_row[1:] = np.minimum(
                current_row[1:],
                np.add(previous_row[:-1], target != s))

        # Deletion (target grows shorter than source):
        current_row[1:] = np.minimum(
                current_row[1:],
                current_row[0:-1] + 1)

        previous_row = current_row

    return previous_row[-1]

def boxToSentence(inputfile1, inputfile2):
    s1 = ''
    with open(inputfile1, 'r') as f:
        for line in f:
            if line[0].isalpha():
                s1 += line[0]

    s2 = ''
    with open(inputfile2, 'r') as f:
        for line in f:
            if line[0].isalpha():
                s2 += line[0]

    return [s1, s2]

s1, s2 = boxToSentence("pretrain.box", "target.box")
print(levenshtein(s1, s2))