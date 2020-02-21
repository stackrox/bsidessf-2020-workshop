---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
weight: "{{ replace .Name "-" " " | title }}"
menu: exercise
#order: "{{ replace .Name "-" " " | order }}"
# order: "{{ first split .Name "-" | order }}"
---
