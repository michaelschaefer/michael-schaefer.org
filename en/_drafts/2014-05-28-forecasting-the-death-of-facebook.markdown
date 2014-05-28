---
layout: post
title: Forecasting the death of Facebook
date: 2014-05-28 14:57:52
description: "Some time a ago I stumbled upon a mathematical paper stating that Facebook will cease to interest a majority of people within the next few years. I will try to explain their epidemiology based approach on a level that does not need advanced calculus."
tags: [Facebook, epidemiology, mathematics]
---

Recently there was a little mathematical paper writte by [Cannarella and Spechler (2014)][CS14] with the title "Epidemiological modeling of online social network dynamics
". The basic message of their work is that they predict that Facebook will undergo a rapid decline and almost nobody will be interested in it anymore within the next few years. For this unusual statement I started to read the paper myself. In the next paragraphs I will try to explain to you how their model works with as less advances calculus as possible.

## The model

The basic idea behind the mathematical model in the paper is what we call an *epidemiology model* or *SIR* model where the letters stand for *S*usceptibles, *I*nfected and *R*ecovered. In the world of diseases, *S* represents the number of people who are well but still can get a certain disease, whereas *I* and *R* are the number of already ill resp. cured inhabitants.

The crucial assumption behind this model is that people are immunized so that once they recover they will not become ill for a second time. The dynamics of the system is thus the following: With time going on, more and more healthy people from group *S* become ill, meaning that they move to group *I*. On the other hands the disease is curable, so some of the ill people recover and move from group *I* to *R*. In the standard *SIR* model the number of people moving form *I* to *R* does not depend on the total number of recovered people.

![][facebook]
![][myspace]


[CS14]: http://arxiv.org/pdf/1401.4208v1.pdf
[facebook]: /media/images/facebook.png
[myspace]: /media/images/myspace.png
