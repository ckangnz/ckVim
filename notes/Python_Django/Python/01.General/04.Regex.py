# re = regular expression
import re

patterns = ['term1', 'term2']
text= 'This is a string with term1, not the other!'

for pattern in patterns:
    print("I'm searching for : "+pattern)

    if re.search(pattern, text):
        print("MATCH!")
    else:
        print("NO MATCH")

match = re.search('term1',text)
print(type(match))
print(match.start())
print(match.end())

match2= re.findall('match', 'test phrase match in middle')
print(match2)


def multi_re_find(patterns, phrase):
    for pat in patterns:
        print("Searching for pattern {}".format(pat))
        print(re.findall(pat,phrase))
        print('\n')

test_phrase = 'sdsd..sssddd..sdddsddd...dsds...dsssssss...sddddd'
test_pattern = ['sd*']
test_pattern = ['sd+']
test_pattern = ['sd?']
test_pattern = ['sd{3}']
test_pattern = ['sd{1,3}']
test_pattern = ['s[sd]+']
test_pattern = ['s[sd]+']

multi_re_find(test_pattern, test_phrase)
