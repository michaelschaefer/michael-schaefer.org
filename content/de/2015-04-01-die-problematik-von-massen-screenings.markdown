title: Die Problematik von Massen-Screenings
date: 2015-04-01
lang: de
tags: mathematik

Für viele Krankheiten gibt es sogenannte Screening-Programme, bei denen mehr oder weniger große Teile der Bevölkerung aufgerufen sind sich speziellen Tests zu unterziehen, mit denen bestimmte Krankheiten frühzeitig erkannt werden sollen. Das wohl bekannteste und am weitesten verbreitete Beispiel ist das Mammographie-Screening. Gerade dort wird immer wieder Kritik am Nutzer des Programms laut weil insbesondere die Zahl der Fehldiagnosen hoch ist. Ich möchte in diesem Artikel mit relativ einfacher Mathematik eine Kennzahl herleiten, die eine erste Beurteilung der Qualität solcher Tests möglich macht. Als konkretes Rechenbeispiel werde ich das bereits erwähnte Mammographie-Screening sowie HIV-Tests anführen.

## Bedingte Wahrscheinlichkeiten

Grundlage der Modellierung werden sogenannte [bedingte Wahrscheinlichkeiten][condprob] sein. Dazu betrachten wir zwei verschiedene Ereignisse `$A$` und `$B$`. Die bedingte Wahrscheinlichkeit `$P(B \mid A)$` (lies: Wahrscheinlichkeit für `$B$` gegeben `$A$`) gibt also die Wahrscheinlichkeit für das Eintreffen des Ereignisses `$A$` an unter der Bedingung, dass das Ereignis `$B$` bereits eingetreten ist. Als Beispiel werfen wir nacheinander zwei Würfel. Das Ereignis `$A$` laute "der erste Würfel zeigt eine 3". Ist nun `$B$` das Ereignis "die Summe der Augen auf beiden Würfeln ist genau 3", so ist `$P(B \mid A) = 0$`, denn der erste Würfel zeigt ja bereits 3 Augen an, und vom zweiten kommt mindestens noch eines hinzu. Ist andererseits `$B$` das Ereignis "die Augensumme ist größer als 6", so gilt `$P(B \mid A) = \frac{3}{6} = \frac{1}{2}$`, denn falls der zweite Würfel die Augenzahl 4, 5 oder 6 zeigt ist es erfüllt.

Für das Rechnen mit bedingten Wahrscheinlichkeiten ist der [Satz von Bayes][bayes] ein unverzichtbares Hilfsmittel. Seine Formulierung lautet 
`$$ P(B \mid A) = \frac{P(A \mid B) \cdot P(B)}{P(A)}. $$`
Die Formel beschreibt also wie man eine bedingte Wahrscheinlichkeit aus der umgedrehten berechnen kann. Sei nun noch `$\bar{B}$` das Gegenereignis zu `$B$`, so gilt nach dem [Gesetz der totalen Wahrscheinlichkeit][totalprob]: 
`$$ P(A) = P(A \mid B) \cdot P(B) + P(A \mid \bar{B}) \cdot P(\bar{B}). $$`
Wenn man dies in die erste Formel einsetzt, so erhält man 
`$$ \begin{equation} P(B \mid A) = \frac{P(A \mid B) \cdot P(B)}{P(A \mid B) \cdot P(B) + P(A \mid \bar{B}) \cdot P(\bar{B})} \label{eq:1} \end{equation} $$`

## Stochastisches Modell

Zur allgemeinen Modellierung sei eine Population betrachtet, deren Mitglieder eine bestimmte Krankheit haben oder nicht. Außerdem gebe es einen Test, der für jede Person entweder ein positives oder negatives Ergebnis liefert. Mit `$G$` (gesund) wollen wir das Ereignis bezeichnen, dass eine Person gesund ist und mit `$P$` (positiv), dass der Test positiv ausgefallen ist. Die entsprechenden Gegenereignisse (also dass die Person gesund bzw. der Test negativ ist) seien `$K$` (krank) und `$N$` (negativ). Weitere wichtige Größen sind:

* Prävalenz `$p$`, das ist der Anteil der Population, der krank ist
* Sensitivität `$\alpha$`, das ist der Anteil der kranken Personen, für die der Test positiv ist (Beispiel: `$\alpha = 0.95$` bedeutet, dass von 100 kranken Personen bei 95 der Test positiv ausfällt)
* Spezifität `$\beta$`, das ist der Anteil der gesunden Personen, für die der Test negativ ist (Beispie: `$\beta = 0.99$` bedeutet, dass von 100 gesunden Personen bei 99 der Test negativ ausfällt)

Übersetzt in die Sprache der Wahrscheinlichkeiten gilt nun offenbar `$p = P(K)$`, `$\alpha = P(P \mid K)$` und `$\beta = P(N \mid G)$`, und als Gegenwahrscheinlichkeiten erhält man 
`$$ \begin{align*} P(G) &= 1 - P(K) = 1-p, \\ P(P \mid G) &= 1 - P(N \mid G) = 1-\beta, \\ P(N \mid K) &= 1-P(P \mid K) = 1-\alpha. \end{align*} $$`
Definieren wir 
`$$ \gamma := \frac{P(G \mid P)}{P(K \mid P)} $$`
so gibt `$\gamma$` an, wieviel mal wahrscheinlicher es ist trotz eines positiven Testergebnisses gesund zu sein. Für einen guten Test sollte dieser Wert also möglichst niedrig sein. Mit Hilfe von Formel `$\eqref{eq:1}$` berechnen wir zunächst
`$$
	\begin{align*}
		P(G \mid P) &= \frac{P(P \mid G) \cdot P(G)}{P(P \mid G) \cdot P(G) + P(P \mid K) \cdot P(K)} \\ &= \frac{(1-\beta)(1-p)}{(1-\beta)(1-p) + \alpha p}, \\
		P(K \mid P) &= \frac{P(P \mid K) \cdot P(K)}{P(P \mid K) \cdot P(K) + P(P \mid G) \cdot P(G)} \\ &= \frac{\alpha p}{\alpha p + (1-\beta)(1-p)}
	\end{align*}
$$`
Wenn man dies nun in die Definition von `$\gamma$` einsetzt kann man viel wegkürzen und es ergibt sich folgende Formel, die nur noch die Testgrößen `$p$`, `$\alpha$` und `$\beta$` enthält:
`$$ \begin{equation} \gamma = \frac{1-\beta}{\alpha} \cdot \frac{1-p}{p}. \label{eq:2} \end{equation} $$`

## Beispiel: Mammographie

Es ist nicht ganz einfach für die Mammographie verlässliche und vor allem aktuelle Werte zu Sensitivität und Spezifität zu finden. Die im [Wikipedia-Artikel][wikiMammo] gefundenen Daten `$\alpha=0.83$` und `$\beta=0.97$` decken sich jedoch in etwa mit einigen Studien, etwa [dieser][KGMC2000], weshalb ich sie hier verwenden möchte. Zur Prävalenz gibt es einige Aussagen vom [Robert-Koch-Institut][rki_brust] (S. 77ff), die einen Wert von `$p = 0.009$` nahelegen. Wenn man alle diese Werte in die obige Formel `$\eqref{eq:2}$` einsetzt erhält man
`$$ \gamma_{\text{mammo}} = \frac{0.03 \cdot 0.991}{0.83 \cdot 0.009} \approx 3.98 $$`
Dies bedeutet: Wenn eine Frau bei der Mammographie einen positiven Befund erhält ist es trotzdem fast viermal wahrscheinlicher, dass sie keinen Brustkrebs hat als dass die Diagnose tatsächlich stimmt. Noch deutlicher wird das Ungleichgewicht, wenn man es in absolute Zahlen umrechnet (die notwendigen Berechnung führe ich hier nicht weiter aus). Aus den Raten vom RKI lässt sich schließen, dass es in Deutschland insgesamt zum Untersuchungszeitpunkt etwa 42.9 Millionen Frauen gab. Wenn man nun bei allen eine Mammographie durchführen würde, so würde man etwa 1.6 Millionen positive Tests erhalten, von denen aber nicht weniger als 1.2 Millionen eigentlich gesund und nur etwa 400000 tatsächlich krank sind. Diese Zahlen alleine sollten Grund genug sein, den Sinn solcher Screenings zumindest kritisch zu hinterfragen.

## Beispiel 2: HIV-Test

Ein weiteres sehr relevantes Beispiel ist der HIV-Test. Denn obwohl die Standardtests teilweise über eine extrem hohe Genauigkeit von bis zu `$\alpha = \beta = 0.999$` verfügen, ist die Aussagekraft bei einem einzelnen positiven Test gering. Dies liegt an der extrem niedrigen Prävalenz: Das [Robert-Koch-Institut][rki_hiv] schätzte Ende 2013 die Zahl der HIV-Infizierten in Deutschland auf etwa 80000, was zum damaligen Zeitpunkt eine Prävalenz von `$p \approx 0.0011$` ergab. Daraus berechnet sich
`$$ \gamma_{\text{HIV}} = \frac{0.001 \cdot 0.9989}{0.999 \cdot 0.0011} \approx 0.91 $$`
Dies wiederum bedeutet, dass die Wahrscheinlichkeit bei einem positiven HIV-Test dennoch gesund zu sein nur geringfügig niedriger ist als die, dass man wirklich krank ist. Aus diesem Grund werden bei positiven HIV-Tests stets weitere Tests durchgeführt um tatsächlich sicher zu gehen.



[bayes]: http://de.wikipedia.org/wiki/Satz_von_Bayes
[condprob]: http://de.wikipedia.org/wiki/Bedingte_Wahrscheinlichkeit
[rki_brust]: http://edoc.rki.de/documents/rki_fv/re2vZ2t28Ir8Y/PDF/23GSS31yB0GKUhU.pdf
[rki_hiv]: http://www.rki.de/DE/Content/InfAZ/H/HIVAIDS/Epidemiologie/Daten_und_Berichte/EckdatenDeutschland.pdf?__blob=publicationFile
[totalprob]: http://de.wikipedia.org/wiki/Bedingte_Wahrscheinlichkeit#Gesetz_der_totalen_Wahrscheinlichkeit
[wikiMammo]: http://de.wikipedia.org/wiki/Mammographie#Kritik_am_Mammographie-Screening
[KGMC2000]: http://www.ncbi.nlm.nih.gov/pubmed/11002452