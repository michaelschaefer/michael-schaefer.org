---
layout: post
title: Das Problem mit den Damen
date: 2014-11-25 14:42:00
tags: [c++, schach]
---

In den vergangenen zwei Wochen hat mal wieder die Schachweltmeisterschaft stattgefunden. Ich habe das zwar nur am Rande verfolgt, bin in dem Zusammenhang aber mal wieder über ein altes Rätsel gestoßen, das sogenannte [Damenproblem][damenproblem]. Die ursprüngliche Aufgabe besteht dabei darin, auf ein normales Schachbrett der Größe 8 x 8 genau acht Damen so zu platzieren, dass keine die jeweils anderen sieben schlagen kann (zur Erinnerung: eine Dame kann horizontal, vertikal und diagonal ziehen). Die Frage nach der Anzahl solcher Lösungen wurde erstmals 1848 gestellt und 1850 beantwortet: Es sind 92.

## Verallgemeinerung und Lösungsansatz

Nun lässt sich dieses Problem natürlich verallgemeinern und nach der Anzahl der Möglichkeiten fragen, wie man entsprechend *n* Damen auf einem Schachbrett der Größe `$n$` x `$n$` konfliktfrei positionieren kann. Für kleine Bretter kann man dies oft noch systematisch von Hand durchprobieren, gerät bei dieser Technik jedoch schnell an die Grenzen des Machbaren. Es liegt daher nahe, ein Computerprogramm zur Beantwortung dieser Frage zu schreiben. Dazu sollte man sich natürlich zunächst eine geeignete Lösungsstrategie überlegen.

Der einfachste Ansatz ist, einfach systematisch alle Möglichkeiten auszuprobieren, wie man die `$n$` Damen auf dem Schachbrett positionieren kann. Man sieht aber schnell ein, dass das viel zu ineffizient ist, da die meisten der sich ergebenden Verteilungen schon nach wenigen Damen eine Kollision auslösen. Abgesehen davon muss man schon für das ursprüngliche Problem nicht weniger als `$\frac{64!}{56!} \approx 1.8 \cdot 10^{14}$`, also rund 180 Billionen, Kombinationen testen.

Ein wesentlich effizienterer und zugleich nicht viel komplizierterer Algorithmus ist das sogenannte [Backtracking][backtracking]. Vereinfacht ausgedrückt geht man dabei so vor, dass man so lange Damen auf dem Brett verteilt bis ein Konflikt auftritt, das heißt, dass eine Dame eine andere schlagen kann. Passiert dies, so geht man zum letzten konfliktfreien Zustand zurück und konstruiert von dort ausgehend eine andere Lösung. Wir wollen das Verfahren einmal exemplarisch auf dem Brett der Größe 4 durchführen.

![][example]

*Bild (a)*: Man beginnt damit, eine Dame im oberen linken Feld zu positionieren. Die von dieser Dame bedrohten Felder werden grau hervorgehoben, hier lassen sich also keine weiteren Damen platzieren. *Bild (b)*: Das erste freie Feld für die zweite Dame ist daher das dritte in der zweiten Reihe. Setzt man sie dort hin, sind nun bis auf eines alle Felder bedroht. Diese Positionierung kann also nicht zu einer gültigen Lösung führen, da ja noch zwei Damen auf das Feld müssen. *Bild (c)*: Wir starten also wieder mit der letzten konfliktfreien Konfiguration aus (a). Hellrot markiert ist das Feld, welches vorhin zu einem Problem führte. *Bild (d)*: Als ersten freies Feld für die zweite Dame finden wir das letzte in der zweiten Reihe. Markiert man auch hier wieder in grau die bedrohten Feld so erkennt man, dass auch diese Konfiguration nicht zu einer Lösung führen kann: Die zwei noch fehlenden Damen können nur so auf das Brett gestellt werden, dass sie sich gegenseitig bedrohen. *Bild (e)*: Da es offenbar zu keiner Lösung führt wenn man die erste Dame oben links platziert, stellen wir sie nun auf das zweite Feld der ersten Reihe. *Bild (f) - (g)*: Das Besetzen des jeweils nächsten freien Feldes führt nun zu einer gültigen Lösung. Führt man dieses Verfahren weiter, so kann man Schritt für Schritt alle gültigen Lösungen finden.

## Programmierung

Für kleine Programme dieser Art verwende ich gerne [Python][python], habe mich aus Performance-Gründen aber diesmal für C++ entschieden. Wer sich den Code anschauen möchte kann das gerne tun: [nqueens.cc][nqueens.cc]. Da die Rechenzeit mit steigender Brettgröße recht schnell ansteigt erlaubt das Programm paralleles Rechnen, das heißt es kann die Berechnungen auf mehrere Prozessoren verteilen, wodurch man schneller zum gewünschten Ergebnis kommt. Damit das funktioniert, muss man eine Bibliothek installiert haben, die das Interface [MPI][mpi] implementiert. Ich verwende dazu [Open MPI][openmpi]. Unter Linux lässt sich das Programm dann mit den folgenden Befehlen kompilieren und ausführen:

{% highlight bash %}
mpic++ -O3 -o nqueens nqueens.cc
mpirun -n p ./nqueens n
{% endhighlight %}

Dabei ist p durch die Anzahl der zu benutzenden Prozessoren und n durch die gewünschte Größe des Brettes zu ersetzen.

## Ergebnisse

Die Anzahl der Lösungen sind für Bretter bis zur Größe 26 x 26 bekannt und können im oben bereits verlinkten Wikipedia-Artikel nachgelesen werden. Ich möchte statt dessen zeigen, dass sich die Parallelisierung dieses Problems tatsächlich lohnt. Dazu habe ich das Programm auf einem Mehrkern-Rechner für die Brettgröße 16 auf ein bis 12 Prozessoren laufen lassen.

In dem Diagramm ist der sogenannte Speed-up aufgetragen. Er berechnet sich so: Bezeichnen wir mit `$t_n$` die Laufzeit des Programms unter Verwendung von `$n$` Prozessoren, so ist der Speed-up `$s_n$` definiert als `$s_n := \frac{t_1}{t_n}$`. Für den Speed-up gilt im Optimalfall `$s_n = n$`, was bedeutet, dass das Programm etwa bei 4 Prozessoren genau ein Viertel der Rechenzeit wie bei einem Prozessor benötigt. In der Praxis erreicht man diese Werte selten bis nie. Das gilt auch für mein Programm. Man sieht aber, dass es mit 12 Prozessoren immerhin mehr als 8 mal so schnell rechnet wie auf einem.


[backtracking]: http://de.wikipedia.org/wiki/Backtracking
[damenproblem]: http://de.wikipedia.org/wiki/Damenproblem
[example]: /media/images/chess.svg
[mpi]: http://de.wikipedia.org/wiki/Message_Passing_Interface
[nqueens.cc]: /media/code/nqueens.cc
[openmpi]: http://www.open-mpi.org/
[python]: http://www.python.org