import re
from collections import Counter
import os
import ConfigParser

Config = ConfigParser.ConfigParser()
present_working_dir = os.getcwd()
Config.read(os.path.join(present_working_dir,"property.ini"))
Documnets = Config.get('path','doc_file')
documnet_path = os.path.join(present_working_dir, Documnets)


def words(text):
    return re.findall(r'\w+', text.lower())
    # words_list = []
    # sentence_list = [(sentence.split(" ")) for sentence in text.lower().split("\n")]
    #
    # for sentence in sentence_list:
    #     words_list.extend(set(sentence))
    #     # print words_list
    #     for idx in range(0,len(sentence)-1):
    #          words_list.append(" ".join([sentence[idx],sentence[idx+1]]))
    #
    # return  words_list

WORDS = Counter(words(open(documnet_path).read()))
#print "WORDS:",WORDS

def P(word, N=sum(WORDS.values())):
    "Probability of `word`."
    return WORDS[word] / N


def correction(word):
    "Most probable spelling correction for word."
    return max(candidates(word), key=P)


def candidates(word):
    "Generate possible spelling corrections for word."
    return (known([word]) or known(edits1(word)) or known(edits2(word)) or [word])


def known(words):
    "The subset of `words` that appear in the dictionary of WORDS."
    return set(w for w in words if w in WORDS)


def edits1(word):
    "All edits that are one edit away from `word`."
    letters = 'abcdefghijklmnopqrstuvwxyz'
    splits = [(word[:i], word[i:]) for i in range(len(word) + 1)]
    deletes = [L + R[1:] for L, R in splits if R]
    transposes = [L + R[1] + R[0] + R[2:] for L, R in splits if len(R) > 1]
    replaces = [L + c + R[1:] for L, R in splits if R for c in letters]
    inserts = [L + c + R for L, R in splits for c in letters]
    return set(deletes + transposes + replaces + inserts)


def edits2(word):
    "All edits that are two edits away from `word`."
    return (e2 for e1 in edits1(word) for e2 in edits1(e1))

def sentence_correction(sentence):

    term = sentence.split(" ")
    #print "Term:",term
    correct_terms = []

    for word in term:
        correct_terms.append(correction(word))
    return " ".join(correct_terms)



if __name__ == "__main__":
    while True:
        sentence = raw_input()
        words = sentence.lower().split(" ")

        correct_words = []
        for word in words:
            correct_words.append(correction(word))
        print " ".join(correct_words)
