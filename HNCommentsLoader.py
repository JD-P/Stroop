# https://archive.org/details/HackerNewsStoriesAndCommentsDump
# run: python3 HNCommentsLoader.py /path/to/your/copy/of/dump | sbcl --dynamic-space-size 1500 --control-stack-size 1000 --load make-frequency-table.lisp > dictionary.txt
# I tried for a very long time to fix the Lisp code so it doesn't need so much memory, but I can't figure it out so I'm moving on.

import ijson
import re
import argparse
import time
import sys

def html_strip(text):
    text = text.replace("&#x27;", "'")
    text = text.replace("&amp;", "&")
    text = text.replace("“", '"')
    text = text.replace("&quot;", '"')
    text = text.replace("&#x2F;", "/")
    return re.sub('<[^<]+?>', '', text)

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument("filepath", help=("Filepath to the Hacker "
                                          "News Comments file."))

arguments = arg_parser.parse_args()

comments_file = open(arguments.filepath)
parser = ijson.parse(comments_file)

comment_count = 0
for prefix, event, value in parser:
    if prefix.endswith("comment_text.value") and value is not None:
        print(html_strip(value))
        comment_count += 1
        sys.stderr.write(str(comment_count) + "\n")
