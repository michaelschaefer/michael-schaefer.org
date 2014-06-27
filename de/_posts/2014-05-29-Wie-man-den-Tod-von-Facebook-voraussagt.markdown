---
layout: post
title: Wie man den Tod von Facebook voraussagt
date: 2014-05-29 14:11:53
description: "Wird Facebook in den n&auml;chsten Jahren aussterben? Ein k&uuml;rzlich ver&ouml;ffentlichter mathematischer Artikel behauptet genau das. Ich m&ouml;chte versuchen im Detail zu erkl&auml;ren, wie man zu dieser Schlussfolgerung kommt. Dabei soll so wenig h&ouml;here Mathematik wie m&ouml;glich verwendet werden."
tags: [Facebook, Epidemiologie, Mathematik]
---

Anfang des Jahres erschien ein kleiner mathematischer Artikel von [Cannarella und Spechler (2014)][CS14] mit dem Titel &quot;Epidemiological modelling of online social network dynamics&quot;. Die Hauptaussage ihrer Arbeit ist die, dass Facebook einen rasanten Abstieg vor sich hat und sich in ein paar Jahren fast niemand mehr daf&uuml;r interessieren wird. Da diese Aussage doch recht ungew&ouml;hnlich ist habe ich den Artikel selbst gelesen und die zur Reproduktion der Ergebnisse notwendige Software programmiert. In den n&auml;chsten Abs&auml;tzen versuche ich die ganze Sache mit m&ouml;glichst wenig h&ouml;herer Mathematik zu erkl&auml;ren.

## Das Modell

Die grundlegende Idee hinter dem Artikel ist das, was wir ein *epidemiologisches Modell* oder kurz *SIR-Modell* nennen. Dabei stehen die Buchstaben f&uuml;r *S*usceptibles (engl. f&uuml;r Anf&auml;llige), *I*nfected (Infizierte) und *R*ecovered (Genesene). In der Welt der Krankheiten bedeutet dies, dass *S* die Anzahl der Leute bezeichnet, die eine bestimmte Krankheit noch bekommen k&ouml;nnen, w&auml;hrend *I* und *R* die bereits infizierten bzw. schon genesenen Menschen sind.

Dem Modell liegen zwei wichtige Annahmen zu Grunde: Die Krankheit ist nicht t&ouml;dlich (d.h. niemand stirbt an ihr) und man immunisiert sich, so dass jeder der sich einmal angesteckt hat anschlie&szlig;end nicht wieder erkranken kann. Die Dynamik des Systems ist daher wie folgt gegeben: Ein bestimmter (fester) Anteil *c* &gt; 0 an gesunden, aber noch nicht immunisierten Menschen aus der Gruppe *S* wird krank und geht daher in die Gruppe *I* &uuml;ber. Auf der anderen Seite werden (wieder mit einer festen Rate *w* &gt; 0) kranke Menschen gesund und verlassen daher die Gruppe *I* in Richtung *R*.

Ich m&ouml;chte dies nun kurz in mathematischer Fachsprache ausdr&uuml;cken. Die oberen Ideen lassen sich in einem sogenannten System gew&ouml;hnlicher Differentialgleichungen zusammenfassen. Grob gesprochen ist eine Differentialgleichung eine Gleichung, in der Ableitungen einer Funktion (das ist ihre &Auml;nderungsrate, d.h. ob sie steigt oder f&auml;llt) mit der Funktion selbst (und evtl. weiteren Funktionen) in Beziehung gesetzt werden. F&uuml;r das SIR-Modell gibt es drei Funktionen, n&auml;mlich *S(t)*, *I(t)* und *R(t)*, wobei *t* die Zeit bezeichnet. Das Modell besteht nun aus den folgenden drei Gleichungen:

(1) *S'(t) = -c I(t) S(t)*<br/>
(2) *I'(t) = &amp;nbsp;c I(t) S(t) - w I(t)*<br/>
(3) *R'(t) = &amp;nbsp;w I(t)*

Zus&auml;tzlich zu den Gleichungen muss man noch sogenannte Anfangswerte vorgeben, d.h. man spezifiziert, welche Werte die Funktionen zur Zeit *t* = 0 annehmen sollen.

## Was ist jetzt mit den sozialen Netzwerken?

Wir haben jetzt das SIR-Modell eingef&uuml;hrt (und hoffentlich grob verstanden). Das Modell wird in dem Artikel durch folgende Analogien mit sozialen Netzwerken in Verbindung gebracht: *S* &uuml;bernimmt die Rolle der Menschen die einem bestimmten Netzwerk noch nicht beigetreten sind, jedoch grunds&auml;tzlich dazu bereit w&auml;ren. *I* hingegen sind die Nutzer und mit *R* bezeichnen wir die Personen, die entweder aus dem Netzwerk ausgetreten sind oder (im Gegensatz zu denen in *S*) grunds&auml;tzlich nicht bereit sind, sich dort anzumelden. Mit diesen Informationen k&ouml;nnten wir eigentlich den Lebenszyklus eines sozialen Netzwerkes simulieren. In dem Artikel wird jedoch eine kleine Modifikation des urspr&uuml;nglichen Modells verwendet, n&auml;mlich das *irSIR-Modell* (dabei steht das *ir* f&uuml;r *i*nfectious *r*ecovery). Die Modifikationen betreffen die Gleichungen (2) und (3), welche durch die folgenden ersetzt werden.

(2a) *I'(t) = c I(t) S(t) - w I(t) R(t)*<br/>
(3a) *R'(t) = w I(t) R(t)*

Mit dieser Ab&auml;nderung versucht man den Effekt zu modellieren, dass Menschen die ein Netzwerk verlassen andere dazu bewegen k&ouml;nnen, das gleiche zu tun (wenn alle Freunde Facebook verlassen wird es wahrscheinlicher, dass man das auch tun wird).

## Datenbeschaffung und Simulation

Wir haben nun ein geeignetes Modell zur Hand. Doch mit welchen Daten sollen wir es f&uuml;ttern? Am einfachsten kommt man &uuml;ber [Google Trends][googletrends] an geeignete Messwerte. Nach ein paar Nachbearbeitungsschritten kann man diese Daten benutzen und versuchen die Parameter des Modells so zu w&auml;hlen, dass die sich ergebende Infektionsrate *I(t)* eben dieses Daten m&ouml;glichst gut erkl&auml;rt. Aber was genau sind diese Parameter? Wenn man sich das Modell anschaut findet man genau f&uuml;nf davon, n&auml;mlich die Raten *c* und *w* sowie die drei Anfangswerte *S(0)*, *I(0)* und *R(0)*, mit denen die Dynamik startet. Wer sich etwas genauer anschauen m&ouml;chte wie man solch ein System simuliert und die optimalen Parameter herausfinden, der kann sich die Daten f&uuml;r Facebook und MySpace zusammen mit den notwendigen Programmen von meinem [Github][github-social] herunterladen.

## Ergebnisse

Zuerst besch&auml;ftigen sich die Autoren mit MySpace. Das hat einen einfachen Grund: Da fast niemand mehr MySpace benutzt kann dessen Lebenszyklus als quasi vollst&auml;ndig betrachtet werden, was es zu einem sehr guten Testfall f&uuml;r das irSIR-Modell macht. Unten sieht man einen Graphen mit den Ergebnissen. Die blaue Kurve zeigt die nachbearbeiteten Daten von Google Trends. Sie sind in der Weise normalisiert, dass das absolute Maximum dem Wert 100 entspricht. Die rote Kurve ist das Simulationsergebnis der Funktion *I(t)* f&uuml;r die vom Programm zu den gegebenen Daten ermittelten optimalen Parameter. Man sieht, dass die Dynamik ziemlich gut wiedergegeben wird. Die gr&uuml;ne Linie markiert den Punkt, wo das Interesse an dem Netzwerk unter 20% des Maximums f&auml;llt, was die Autoren in etwa als &quot;Todeszeitpunkt&quot; interpretieren. In diesem Fall lag er bei Ende 2010.

![][myspace]

Nun zu Facebook. Dieser Fall ist interessanter, weil das Netzwerk noch lebendig ist, d.h. die blaue Datenkurve liegt &uuml;ber der 20%-Linie. Ich habe wieder Simulationen durchgef&uuml;hrt und die optimalen Parameter ermitteln lassen. Die sich ergebende am besten passende Kurve ist wieder in rot eingezeichnet. Man sieht, dass die Simulation ein rasantes Abklingen des Interesses an Facebook in den n&auml;chsten Jahren voraussagt. Im Ergebnis wird der &quot;Todeszeitpunkt&quot;, also das Fallen unter die 20%-Linie, etwa Ende 2015 stattfinden.

![][facebook]

## Interpretation

Wie soll man mit solchen Ergebnissen umgehen? Auf den ersten Blick sieht so etwas schnell sehr &uuml;berzeugend aus, da es ja mathematisch fundiert ist. Ich w&uuml;rde jedoch nicht zu viel auf solche Vorhersagen geben. Dies hat haupts&auml;chlich zwei Gr&uuml;nde. Zum einen sollte man sich fragen, ob der Einsatz von Google Trends Daten sinnvoll ist. Nicht jeder sucht bei Google, was die Ergebnisse verf&auml;lschen k&ouml;nnte. Wichtiger ist meiner Meinung nach jedoch, dass die Menge der Suchanfragen zu &quot;Facebook&quot; nicht wirklich viel dar&uuml;ber aussagt, was im Netzwerk passiert. So lange die Leute nicht nach Facebook suchen aber es trotzdem benutzen ist das Netzwerk lebendig, obwohl das Modell etwas anderes aussagt. Der zweite und aus mathematischer Sicht wichtigere Einwand ist das Modell selbst. Kurven an Daten anzupassen ist eine nette Sache. Daraus Vorhersagen f&uuml;r die Zukunft abzuleiten ist jedoch etwas ganz anderes. Es gibt ein Zitat des bekannten Mathematikers John von Neumann, der einmal (etwas frei &uuml;bersetzt) gesagt hat: &quot;Mit vier Parametern kann ich einen Elefanten zeichnen lassen und mit f&uuml;nf kann ich ihm mit dem Schwanz wackeln lassen&quot;. Was er damit sagen m&ouml;chte ist, dass man mit einer ausreichenden Menge an Parametern quasi jede Datenmenge durch ein geeignetes mathematisches Modell erkl&auml;ren kann. Das f&uuml;hrt uns zu dem Schluss, dass unser irSIR-Modell die Daten m&ouml;glicherweise nur zuf&auml;llig erkl&auml;rt, jedoch das tats&auml;chliche intrinsische Verhalten sozialer Netzwerke gar nicht widerspiegelt. Ich pers&ouml;nlich halte dies angesichts der Komplexit&auml;t menschlichen Verhaltens auch f&uuml;r sehr fraglich. So ist es gut m&ouml;glich, dass es Modelle gibt die die Google-Daten mindestens genau so gut beschreiben, aber zu v&ouml;llig anderen Schlussfolgerungen f&uuml;r die Zukunft f&uuml;hren.


[CS14]: http://arxiv.org/pdf/1401.4208v1.pdf
[facebook]: /media/images/facebook.png
[github-social]: https://github.com/michaelschaefer/social-network-modelling
[googletrends]: http://trends.google.com/trends/
[myspace]: /media/images/myspace.png
