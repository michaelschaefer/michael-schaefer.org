title: Wie man den Tod von Facebook voraussagt
date: 2014-05-29
lang: de
tags: epidemiologie, mathematik, python

Anfang des Jahres erschien ein kleiner mathematischer Artikel von [Cannarella und Spechler (2014)][CS14] mit dem Titel &quot;Epidemiological modelling of online social network dynamics&quot;. Die Hauptaussage ihrer Arbeit ist die, dass Facebook einen rasanten Abstieg vor sich hat und sich in ein paar Jahren fast niemand mehr dafür interessieren wird. Da diese Aussage doch recht ungewöhnlich ist habe ich den Artikel selbst gelesen und die zur Reproduktion der Ergebnisse notwendige Software programmiert. In den nächsten Absätzen versuche ich die ganze Sache mit möglichst wenig höherer Mathematik zu erklären.

## Das Modell

Die grundlegende Idee hinter dem Artikel ist das, was wir ein *epidemiologisches Modell* oder kurz *SIR-Modell* nennen. Dabei stehen die Buchstaben für *S*usceptibles (engl. für Anfällige), *I*nfected (Infizierte) und *R*ecovered (Genesene). In der Welt der Krankheiten bedeutet dies, dass `$S$` die Anzahl der Leute bezeichnet, die eine bestimmte Krankheit noch bekommen können, während `$I$` und `$R$` die bereits infizierten bzw. schon genesenen Menschen sind.

Dem Modell liegen zwei wichtige Annahmen zu Grunde: Die Krankheit ist nicht tödlich (d.h. niemand stirbt an ihr) und man immunisiert sich, so dass jeder der sich einmal angesteckt hat anschließend nicht wieder erkranken kann. Die Dynamik des Systems ist daher wie folgt gegeben: Ein bestimmter (fester) Anteil `$c > 0$` an gesunden, aber noch nicht immunisierten Menschen aus der Gruppe `$S$` wird krank und geht daher in die Gruppe `$I$` über. Auf der anderen Seite werden (wieder mit einer festen Rate `$w>0$`) kranke Menschen gesund und verlassen daher die Gruppe `$I$` in Richtung `$R$`.

Ich möchte dies nun kurz in mathematischer Fachsprache ausdrücken. Die oberen Ideen lassen sich in einem sogenannten System gewöhnlicher Differentialgleichungen zusammenfassen. Grob gesprochen ist eine Differentialgleichung eine Gleichung, in der Ableitungen einer Funktion (das ist ihre änderungsrate, d.h. ob sie steigt oder fällt) mit der Funktion selbst (und evtl. weiteren Funktionen) in Beziehung gesetzt werden. Für das SIR-Modell gibt es drei Funktionen, nämlich `$S(t)$`, `$I(t)$` und `$R(t)$`, wobei `$t$` die Zeit bezeichnet. Das Modell besteht nun aus den folgenden drei Gleichungen:

`$$
\begin{align}
	S'(t) &= -c I(t) S(t) && (1) \\
	I'(t) &= c I(t) S(t) - w(t) I(t) && (2) \\
	R'(t) &= w I(t) && (3)
\end{align}
$$`

Zusätzlich zu den Gleichungen muss man noch sogenannte Anfangswerte vorgeben, d.h. man spezifiziert, welche Werte die Funktionen zur Zeit `$t = 0$` annehmen sollen.

## Was ist jetzt mit den sozialen Netzwerken?

Wir haben jetzt das SIR-Modell eingeführt (und hoffentlich grob verstanden). Das Modell wird in dem Artikel durch folgende Analogien mit sozialen Netzwerken in Verbindung gebracht: `$S$` übernimmt die Rolle der Menschen die einem bestimmten Netzwerk noch nicht beigetreten sind, jedoch grundsätzlich dazu bereit wären. `$I$` hingegen sind die Nutzer und mit `$R$`  bezeichnen wir die Personen, die entweder aus dem Netzwerk ausgetreten sind oder (im Gegensatz zu denen in `$S$`) grundsätzlich nicht bereit sind, sich dort anzumelden. Mit diesen Informationen könnten wir eigentlich den Lebenszyklus eines sozialen Netzwerkes simulieren. In dem Artikel wird jedoch eine kleine Modifikation des ursprünglichen Modells verwendet, nämlich das *irSIR-Modell* (dabei steht das *ir* für *i*nfectious *r*ecovery). Die Modifikationen betreffen die Gleichungen (2) und (3), welche durch die folgenden ersetzt werden.

`$$
\begin{align}
	I'(t) &= c I(t) S(t) - wI(t) R(t) && (2a) \\
	R'(t) &= w I(t) R(t) && (3a)
\end{align}
$$`

Mit dieser Abänderung versucht man den Effekt zu modellieren, dass Menschen die ein Netzwerk verlassen andere dazu bewegen können, das gleiche zu tun (wenn alle Freunde Facebook verlassen wird es wahrscheinlicher, dass man das auch tun wird).

## Datenbeschaffung und Simulation

Wir haben nun ein geeignetes Modell zur Hand. Doch mit welchen Daten sollen wir es füttern? Am einfachsten kommt man über [Google Trends][googletrends] an geeignete Messwerte. Nach ein paar Nachbearbeitungsschritten kann man diese Daten benutzen und versuchen die Parameter des Modells so zu wählen, dass die sich ergebende Infektionsrate `$I(t)$` eben dieses Daten möglichst gut erklärt. Aber was genau sind diese Parameter? Wenn man sich das Modell anschaut findet man genau fünf davon, nämlich die Raten `$c$` und `$w$` sowie die drei Anfangswerte `$S(0), I(0)$` und `$R(0)$`, mit denen die Dynamik startet. Wer sich etwas genauer anschauen möchte wie man solch ein System simuliert und die optimalen Parameter herausfinden, der kann sich die Daten für Facebook und MySpace zusammen mit den notwendigen Programmen von meinem [Github][github-social] herunterladen.

## Ergebnisse

Zuerst beschäftigen sich die Autoren mit MySpace. Das hat einen einfachen Grund: Da fast niemand mehr MySpace benutzt kann dessen Lebenszyklus als quasi vollständig betrachtet werden, was es zu einem sehr guten Testfall für das irSIR-Modell macht. Unten sieht man einen Graphen mit den Ergebnissen. Die blaue Kurve zeigt die nachbearbeiteten Daten von Google Trends. Sie sind in der Weise normalisiert, dass das absolute Maximum dem Wert 100 entspricht. Die rote Kurve ist das Simulationsergebnis der Funktion `$I(t)$` für die vom Programm zu den gegebenen Daten ermittelten optimalen Parameter. Man sieht, dass die Dynamik ziemlich gut wiedergegeben wird. Die grüne Linie markiert den Punkt, wo das Interesse an dem Netzwerk unter 20% des Maximums fällt, was die Autoren in etwa als &quot;Todeszeitpunkt&quot; interpretieren. In diesem Fall lag er bei Ende 2010.

![Simulationsergebnis für MySpace][myspace]

Nun zu Facebook. Dieser Fall ist interessanter, weil das Netzwerk noch lebendig ist, d.h. die blaue Datenkurve liegt über der 20%-Linie. Ich habe wieder Simulationen durchgeführt und die optimalen Parameter ermitteln lassen. Die sich ergebende am besten passende Kurve ist wieder in rot eingezeichnet. Man sieht, dass die Simulation ein rasantes Abklingen des Interesses an Facebook in den nächsten Jahren voraussagt. Im Ergebnis wird der &quot;Todeszeitpunkt&quot;, also das Fallen unter die 20%-Linie, etwa Ende 2015 stattfinden.

![Simulationsergebnis für Facebook][facebook]

## Interpretation

Wie soll man mit solchen Ergebnissen umgehen? Auf den ersten Blick sieht so etwas schnell sehr überzeugend aus, da es ja mathematisch fundiert ist. Ich würde jedoch nicht zu viel auf solche Vorhersagen geben. Dies hat hauptsächlich zwei Gründe. Zum einen sollte man sich fragen, ob der Einsatz von Google Trends Daten sinnvoll ist. Nicht jeder sucht bei Google, was die Ergebnisse verfälschen könnte. Wichtiger ist meiner Meinung nach jedoch, dass die Menge der Suchanfragen zu &quot;Facebook&quot; nicht wirklich viel darüber aussagt, was im Netzwerk passiert. So lange die Leute nicht nach Facebook suchen aber es trotzdem benutzen ist das Netzwerk lebendig, obwohl das Modell etwas anderes aussagt. Der zweite und aus mathematischer Sicht wichtigere Einwand ist das Modell selbst. Kurven an Daten anzupassen ist eine nette Sache. Daraus Vorhersagen für die Zukunft abzuleiten ist jedoch etwas ganz anderes. Es gibt ein Zitat des bekannten Mathematikers John von Neumann, der einmal (etwas frei übersetzt) gesagt hat: &quot;Mit vier Parametern kann ich einen Elefanten zeichnen lassen und mit fünf kann ich ihm mit dem Schwanz wackeln lassen&quot;. Was er damit sagen möchte ist, dass man mit einer ausreichenden Menge an Parametern quasi jede Datenmenge durch ein geeignetes mathematisches Modell erklären kann. Das führt uns zu dem Schluss, dass unser irSIR-Modell die Daten möglicherweise nur zufällig erklärt, jedoch das tatsächliche intrinsische Verhalten sozialer Netzwerke gar nicht widerspiegelt. Ich persönlich halte dies angesichts der Komplexität menschlichen Verhaltens auch für sehr fraglich. So ist es gut möglich, dass es Modelle gibt die die Google-Daten mindestens genau so gut beschreiben, aber zu völlig anderen Schlussfolgerungen für die Zukunft führen.


[CS14]: http://arxiv.org/pdf/1401.4208v1.pdf
[facebook]: /files/images/facebook.svg
[github-social]: https://github.com/michaelschaefer/social-network-modelling
[googletrends]: http://trends.google.com/trends/
[myspace]: /files/images/myspace.svg
