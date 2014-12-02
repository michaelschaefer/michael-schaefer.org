---
layout: post
title: Das Problem mit den Damen
date: 2014-11-26 16:27:00
tags: [c++, schach]
---

In den vergangenen zwei Wochen hat mal wieder die Schachweltmeisterschaft stattgefunden. Ich habe das zwar nur am Rande verfolgt, bin in dem Zusammenhang aber mal wieder über ein altes Rätsel gestoßen, das sogenannte [Damenproblem][damenproblem]. In diesem Artikel möchte ich dieses Problem und einen Lösungsweg vorstellen. Die ursprüngliche Aufgabe des Damenproblems besteht dabei darin, auf ein normales Schachbrett der Größe 8 x 8 genau acht Damen so zu platzieren, dass keine die jeweils anderen sieben schlagen kann (zur Erinnerung: eine Dame kann horizontal, vertikal und diagonal ziehen). Die Frage nach der Anzahl solcher Lösungen wurde erstmals 1848 gestellt und 1850 beantwortet: Es sind 92.

## Verallgemeinerung und Lösungsansatz

Nun lässt sich dieses Problem natürlich verallgemeinern und nach der Anzahl der Möglichkeiten fragen, wie man entsprechend `$n$` Damen auf einem Schachbrett der Größe `$n$` x `$n$` konfliktfrei positionieren kann. Für kleine Bretter kann man dies oft noch systematisch von Hand durchprobieren, gerät bei dieser Technik jedoch schnell an die Grenzen des Machbaren. Es liegt daher nahe, ein Computerprogramm zur Beantwortung dieser Frage zu schreiben. Dazu sollte man sich natürlich zunächst eine geeignete Lösungsstrategie überlegen.

Der einfachste Ansatz ist, einfach systematisch alle Möglichkeiten auszuprobieren, wie man die `$n$` Damen auf dem Schachbrett positionieren kann. Man sieht aber schnell ein, dass das viel zu ineffizient ist, da die meisten der sich ergebenden Verteilungen schon nach wenigen Damen eine Kollision auslösen. Abgesehen davon muss man schon für das ursprüngliche Problem nicht weniger als `$\frac{64!}{56!} \approx 1.8 \cdot 10^{14}$`, also rund 180 Billionen, Kombinationen testen.

Ein wesentlich effizienterer und zugleich nicht viel komplizierterer Algorithmus ist das sogenannte [Backtracking][backtracking]. Vereinfacht ausgedrückt geht man dabei so vor, dass man so lange Damen auf dem Brett verteilt bis ein Konflikt auftritt, das heißt, dass eine Dame eine andere schlagen kann. Passiert dies, so geht man zum letzten konfliktfreien Zustand zurück und konstruiert von dort ausgehend eine andere Lösung. Wir wollen das Verfahren einmal exemplarisch auf dem Brett der Größe 4 durchführen.

<object data="/media/images/chess-backtracking.svg"><img src="/media/images/chess-backtracking.png" /></object>

*Bild (a)*: Man beginnt damit, eine Dame im oberen linken Feld zu positionieren. Die von dieser Dame bedrohten Felder werden grau hervorgehoben, hier lassen sich also keine weiteren Damen platzieren. *Bild (b)*: Das erste freie Feld für die zweite Dame ist daher das dritte in der zweiten Reihe. Setzt man sie dort hin, sind nun bis auf eines alle Felder bedroht. Diese Positionierung kann also nicht zu einer gültigen Lösung führen, da ja noch zwei Damen auf das Feld müssen. *Bild (c)*: Wir starten also wieder mit der letzten konfliktfreien Konfiguration aus (a). Hellrot markiert ist das Feld, welches vorhin zu einem Problem führte. *Bild (d)*: Als ersten freies Feld für die zweite Dame finden wir das letzte in der zweiten Reihe. Markiert man auch hier wieder in grau die bedrohten Feld so erkennt man, dass auch diese Konfiguration nicht zu einer Lösung führen kann: Die zwei noch fehlenden Damen können nur so auf das Brett gestellt werden, dass sie sich gegenseitig bedrohen. *Bild (e)*: Da es offenbar zu keiner Lösung führt wenn man die erste Dame oben links platziert, stellen wir sie nun auf das zweite Feld der ersten Reihe. *Bild (f) - (h)*: Das Besetzen des jeweils nächsten freien Feldes führt nun zu einer gültigen Lösung. Führt man dieses Verfahren weiter, so kann man Schritt für Schritt alle gültigen Lösungen finden.

## Programmierung

Für kleine Programme dieser Art verwende ich gerne [Python][python], habe mich aus Performance-Gründen aber diesmal für C++ entschieden. Wer sich den Code anschauen möchte kann das gerne tun: [nqueens.cc][nqueens.cc]. Ich möchte nicht das komplette Programm vorstellen, sondern lediglich die wichtigste Funktion näher erläutern, nämlich das Backtracking selbst.

{% highlight c++ linenos %}
int countSolutions(int* queens, int N, int n = 0) {
  int count = 0;  
  for (int i = 0; i < N; ++i) {
    if (n == 0) 
      // print progress
      cout << (100 * i / N) << "% done\r" << flush;
    else {
      // check for direct collision with upper row
      int dx = queens[n-1] - i;
      if (dx > -2 && dx < 2)
        continue;
    }

    queens[n] = i;

    if (!isCollisionFree(queens, N, n)) continue;
    if (n+1 == N) {
      count++;
    } else {
      int* tmp = new int[N];
      for (int j = 0; j < N; ++j) tmp[j] = queens[j];
      count += countSolutions(queens, N, n+1);
      for (int j = 0; j < N; ++j) queens[j] = tmp[j];
      delete[] tmp;
      tmp = 0;
    }
  }

  if (n == 0) cout << "100% done";
  return count;
}
{% endhighlight %}

*Zeile 1*: Zunächst zu den Parametern der Funktion: queens ist ein Array, welches die Positionen der einzelnen Damen innerhalb ihrer jeweiligen Reihe speichert (man überlegt sich leicht, dass eine zulässige Lösung des Damenproblems in jeder Reihe genau eine Dame enthalten muss), noch nicht platzierte Damen werden durch -1 dargestellt. Der Wert N gibt die Dimension des Schachbrettes an und n die Nummer der als nächstes zu setzenden Dame (mit 0 beginnend!). *Zeile 8-11*: Es ist bereits mindestens eine Dame auf dem Brett. Wir können daher direkt überprüfen, ob das als nächstes zu besetzende Feld i der Reihe n bereits durch eine Dame in der Reihe n-1 gedeckt ist. In diesem Fall ergibt sich keine gültige Lösung und wir können direkt mit dem nächsten Feld fortfahren. *Zeile 14*: Die n-te Dame wird in der n-ten Reihe auf das i-te Feld positioniert. *Zeile 16*: Wenn die Dame an dieser Position eine Kollision auslöst kann die Konstellation verworfen werden. *Zeile 18*: Es wurde eine gültige Lösung gefunden, da die N-te Dame konfliktfrei auf dem Brett positioniert werden konnte. *Zeile 20-25*: Es liegt eine konfliktfreie Konstellation vor, die aber noch nicht komplett ist. Wir sichern daher den aktuellen Zustand im Array tmp und rufen die Lösungsfunktion rekursiv selbst auf, wobei als dritter Parameter n+1 angegeben wird, weil nun die (n+1)-te Dame gesetzt werden soll. *Zeile 30*: Nachdem die for-Schleife durchlaufen ist, kann die Anzahl der auf der aktuellen Ebene n gefundenen Lösungen zurückgegeben werden.

Da die Rechenzeit mit steigender Brettgröße recht schnell ansteigt, habe ich das Programm so implementiert, dass es paralleles Rechnen unterstützt, das heißt es kann die Berechnungen auf mehrere Prozessoren verteilen, wodurch man schneller zum gewünschten Ergebnis kommt. Damit das funktioniert, muss man eine Bibliothek installiert haben, die das Interface [MPI][mpi] implementiert. Ich verwende dazu [Open MPI][openmpi]. Unter Linux lässt sich das Programm dann mit den folgenden Befehlen kompilieren und ausführen:

{% highlight bash linenos %}
mpic++ -O3 -o nqueens nqueens.cc
mpirun -n p ./nqueens n
{% endhighlight %}

Dabei ist p durch die Anzahl der zu benutzenden Prozessoren und n durch die gewünschte Größe des Brettes zu ersetzen.

## Ergebnisse

Die Anzahl der Lösungen sind für Bretter bis zur Größe 26 x 26 bekannt und können im oben bereits verlinkten Wikipedia-Artikel nachgelesen werden. Ich möchte statt dessen zeigen, dass sich die Parallelisierung dieses Problems tatsächlich lohnt. Dazu habe ich das Programm auf einem Mehrkern-Rechner für die Brettgrößen 14 bis 17 auf bis zu 17 Prozessoren laufen lassen. Um ein Gefühl für die Komplexität des Problems zu bekommen sei angemerkt, dass die Berechnung mit einem einzigen Prozessor auf dem Brett der Größe 17 etwa 64 Minuten benötigt hat.

<object data="/media/images/chess-speedup.svg"><img src="/media/images/chess-speedup.png" /></object>

In dem Diagramm ist der Beschleunigungsfaktor `$s_n$` aufgetragen, der wie folgt berechnet wird: Bezeichnen wir mit `$t_n$` die Laufzeit des Programms unter Verwendung von `$n$` Prozessoren, so ist `$s_n$` definiert als `$s_n := \frac{t_1}{t_n}$`. Im Optimalfall gilt `$s_n = n$` was bedeutet, dass das Programm etwa bei 2 Prozessoren genau die Hälfte der Rechenzeit wie bei einem Prozessor benötigt. In der Praxis erreicht man diese Werte selten bis nie. Das gilt auch für mein Programm. Man sieht aber, dass es mit 17 Prozessoren immerhin mehr als 14 mal so schnell rechnet wie auf einem. Weiterhin fällt auf, dass die Parallelisierung mit steigender Komplexität des Problems besser funktioniert, da die Kurven mit steigendem `$n$` schneller wachsen. Das ist nicht zufällig so sondern hat seine Ursache in dem Mehraufwand der betrieben werden muss, um die Berechnungen zwischen den einzelnen Prozessoren zu synchronisieren. Steigt die Komplexität der einzelnen Rechnungen, so verschwindet der Mehraufwand schließlich in der gesamten Rechenzeit.


[backtracking]: http://de.wikipedia.org/wiki/Backtracking
[damenproblem]: http://de.wikipedia.org/wiki/Damenproblem
[example]: /media/images/chess.svg
[mpi]: http://de.wikipedia.org/wiki/Message_Passing_Interface
[nqueens.cc]: /media/code/nqueens.cc
[openmpi]: http://www.open-mpi.org/
[python]: http://www.python.org