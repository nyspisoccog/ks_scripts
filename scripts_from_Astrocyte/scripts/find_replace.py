def find(s, ch):
    return [i for i, ltr in enumerate(s) if ltr == ch]

def find_replace(s, f, r):
	inds = find(s, " ")
	if inds:
		t = s[0:inds[0]]
		for i, ind in enumerate(inds):
			
			if i < len(inds) -1 :
				t = t + r + s[ind+1:inds[i+1]]
			else:
				t = t + r + s[ind+1:]
		return t
	return s

string = "The quick brown fox jumped over the lazy dog."

print string

print find_replace(string, " ", "")

print find_replace(string, " ", "\ ")

