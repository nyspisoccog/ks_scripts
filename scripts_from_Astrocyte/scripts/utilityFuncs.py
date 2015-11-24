def split_lines(fyel, delim):
    ###Arg1: text file, Arg2: delimiter
    ###Return: text as list of lists. Outer list: list of lines. Inner lists: lists of line contents.
    lines = fyel.readlines()
    lineslist = []
    for line in lines:
        if line[-1] == '\n': line = line[:-1]
        lineslist.append(line.split(delim))
    return lineslist
