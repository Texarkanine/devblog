---
layout: post
title: "Tabs vs. Spaces in the Age of LLMs"
author: texarkanine
tags:
  - ai
  - code style
---

If you wrote code like this:

```python
class Greeter:
    def __init__(self, name):
        self.name = name

    def hello_world(self):
        greeting = f"Hello, {self.name}!"
        print(greeting)
```

and you saw *me* looking at your code and it looked like *this:*

```python
class Greeter:
 def __init__(self, name):
  self.name = name

 def hello_world(self):
  greeting = f"Hello, {self.name}!"
  print(greeting)
```

**Would you be mad?**

If so, you would be acting like a busybody who can't tolerate other people being different in the privacy of their own lives.

If *that* makes you mad, I'd ask you if you care what font I use in my editors, or what color highlighting scheme I use. If you don't try to force *those* on me, then why do you care so much about how far from the edge of the screen the code appears for me?

If you *would* be mad, that's likely a psychological reaction stemming from emotions and identity, and you're [unlikely to be receptive](https://theoatmeal.com/comics/believe) to any logical arguments as to why tabs are an unequivocally better choice for software engineers to use for indentation when writing code.

## Thesis

> Tabs for indentation, spaces for alignment.

Others have said it before and better than I:

{% linkcard
    https://geometrian.com/projects/blog/tabs_versus_spaces.html
    "TABs vs. Spaces"
    archive:https://web.archive.org/web/20250709040814/https://geometrian.com/projects/blog/tabs_versus_spaces.html
%}

## On Industry Standards

* [PEP 8 says to use spaces for indentation](https://peps.python.org/pep-0008/)
* [YAML says to use spaces for indentation](https://yaml.org/spec/1.2.2/#61-indentation-spaces)
* [Google's JavaScript Style Guide says to use spaces for indentation](https://google.github.io/styleguide/jsguide.html#formatting-block-indentation)
* and on, and, on

Almost all major programming languages as they're used today both advise and use spaces for indentation, not tabs. Let me be clear here:

![Yes, you all are Wrong](./yes-you-all-are-wrong.jpg)

## I Could Be Wrong in 2025

