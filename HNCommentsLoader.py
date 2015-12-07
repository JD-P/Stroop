# https://archive.org/details/HackerNewsStoriesAndCommentsDump

import ijson
import re
import argparse
import time

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

for prefix, event, value in parser:
    if prefix.endswith("comment_text.value") and value is not None:
        print(html_strip(value))
