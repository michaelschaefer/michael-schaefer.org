title: The difficulty of mass screenings
date: 2015-04-01
lang: en
tags: mathematics, statistics

For many diseases there are so-called screening programs where more or less big parts of the population are called to undergo certain tests with the goal to early discover these diseases. The probably best known example is the mammography screening. Especially there public critizism is frequently voiced because the number of misdiagnoses is high. In this article I want to use relatively simple mathematics to deduce an index that allows to judge the quality of such tests. As specific examples I present the already mentioned mammography as well as HIV tests.

## Conditional probabilities

The basis of the modelling will be [conditional probabilities][condprob]. Therefore we consider two events `$A$` and `$B$`. The conditional probability `$P(B \mid A)$` (read: Probability of `$B$` given `$A$`) denotes the probability of the occurrence of event `$A$` under the condition that event `$B$` already happend. As an example we throw two dice. Event `$A$` should be "the first die shows 3". If now `$B$` is the event "the sum on both dice is exactly 3", then obviously `$P(B \mid A) = 0$`, because the first one already shows 3 and the second will add at least one. If on the other hand `$B$` reads "the sum on both dice is bigger than 6", then `$P(B \mid A) = \frac{3}{6} = \frac{1}{2}$`, because this will be true in case the second die shows 4, 5 or 6.

For the calculus of conditional probabilities, [Bayes' theorem][bayes] is essential. Its formulation is
`$$ P(B \mid A) = \frac{P(A \mid B) \cdot P(B)}{P(A)}. $$`
Thus the formula describes how to calculate a conditional probability from the inverted one. In addition, let `$\bar{B}$` denote the complementary event of `$B$`, then the [Law of total probability][totalprob] reads: 
`$$ P(A) = P(A \mid B) \cdot P(B) + P(A \mid \bar{B}) \cdot P(\bar{B}). $$`
Inserting this into the first formula we end up with 
`$$ \begin{equation} P(B \mid A) = \frac{P(A \mid B) \cdot P(B)}{P(A \mid B) \cdot P(B) + P(A \mid \bar{B}) \cdot P(\bar{B})} \label{eq:1} \end{equation} $$`

## Stochastic model

For a general modelling we consider a population whose members have a certain condition or they don't. Furthermore there should be a test that for every person gives either a positive or a negative result. Let `$H$` (healty) be the event of a person being healthy and `$P$` (positive) that the test turns out positive. The corresponding complementary probabilities (the person being sick resp. the test turning out negative) shall be `$S$` (sick) and `$N$` (negativ). Further important quantities are:

* prevalence `$p$`, that is the amount of the population being sick
* sensitivity `$\alpha$`, that is the amout of sick people who get a positive test result (Example: `$\alpha = 0.95$` means that 95 out of 100 sick people will actualy get a positive result)
* specificity `$\beta$`, that is the amount of healthy people who get a negative test result (Example: `$\beta = 0.99$` means that 99 out of 100 healthy people will acually get a negative result)

Translated to the world of probabilities we obviously have `$p = P(S)$`, `$\alpha = P(P \mid S)$` and `$\beta = P(N \mid H)$`, and the complementary probabilities are given as 
`$$ \begin{align*} P(H) &= 1 - P(S) = 1-p, \\ P(P \mid H) &= 1 - P(N \mid H) = 1-\beta, \\ P(N \mid S) &= 1-P(P \mid S) = 1-\alpha. \end{align*} $$` 
If we define 
`$$ \gamma := \frac{P(H \mid P)}{P(S \mid P)} $$`
then `$\gamma$` denotes how much more likely it is to be healthy despite a positive test result. A good test should therefore have a small value of `$\gamma$`. Together with formula `$\eqref{eq:1}$` we calculate
`$$
	\begin{align*}
		P(H \mid P) &= \frac{P(P \mid H) \cdot P(H)}{P(P \mid H) \cdot P(H) + P(P \mid S) \cdot P(S)} \\ &= \frac{(1-\beta)(1-p)}{(1-\beta)(1-p) + \alpha p}, \\
		P(S \mid P) &= \frac{P(P \mid S) \cdot P(S)}{P(P \mid S) \cdot P(S) + P(P \mid H) \cdot P(H)} \\ &= \frac{\alpha p}{\alpha p + (1-\beta)(1-p)}
	\end{align*}
$$`
Putting this into the definition of `$\gamma$` one can cancel out a lot of things, resulting in the following formula which does only depend on the test quantities `$p$`, `$\alpha$` and `$\beta$`:
`$$ \begin{equation} \gamma = \frac{1-\beta}{\alpha} \cdot \frac{1-p}{p}. \label{eq:2} \end{equation} $$`

## Example: Mammography

It is not very easy to get reliable and recent values for sensitivity and prevalence for mammography. The [german Wikipedia article][wikiMammo] refers to `$\alpha=0.83$` and `$\beta=0.97$`. These values will be used since they roughly agree with some studies I found, like [this one][KGMC2000]. For the prevalence there are some statements from the [Robert Koch Institute][rki_brust] (p. 77ff), that suggest a value of `$p = 0.009$` for Germany. If we plug all these values into formula `$\eqref{eq:2}$` we get
`$$ \gamma_{\text{mammo}} = \frac{0.03 \cdot 0.991}{0.83 \cdot 0.009} \approx 3.98 $$`
This means that when a woman undergoes a mammography and gets a positive result it is nevertheless nearly four times more likely that she does not have breast cancer than that the diagnosis is correct. The imbalance becomes even more obvious if we translate this into absolute numbers (I will, however, not carry out the neccessary calculations). From the data of the Robert Koch Institute we can deduce that at the time of the study there were roughly 42.9 million woman in Germany. If each one of them would undergo a mammography, this would end up in about 1.6 million positive test. But from these, not less than 1.2 million are false positives and merely 400,000 acually have breast cancer. These numbers alone should be reason enough to challenge the value of such screenings.

## Example 2: HIV test

Another very relevant example are HIV tests. Although the standard tests partly have an extremely high accuracy of up to `$\alpha = \beta = 0.999$`, the validity of a single test is rather limited.The reason for this is a very low prevalence: The [Robert Koch Institute][rki_hiv] estimated the number of HIV infected people in Germany to about 80,000 at the end of 2013. At that time this meant a prevalence of `$p \approx 0.0011$`. From this we deduce
`$$ \gamma_{\text{HIV}} = \frac{0.001 \cdot 0.9989}{0.999 \cdot 0.0011} \approx 0.91 $$`
This in turn means that the likelihood to be healthy in case of a positive test result is only slightly less than the one of being actually sick. That is the reason why a person with a positive HIV test will directly undergo some additional tests to get a proper result.


[bayes]: http://en.wikipedia.org/wiki/Bayes%27_theorem
[condprob]: http://en.wikipedia.org/wiki/Conditional_probability
[rki_brust]: http://edoc.rki.de/documents/rki_fv/re2vZ2t28Ir8Y/PDF/23GSS31yB0GKUhU.pdf
[rki_hiv]: http://www.rki.de/DE/Content/InfAZ/H/HIVAIDS/Epidemiologie/Daten_und_Berichte/EckdatenDeutschland.pdf?__blob=publicationFile
[totalprob]: http://en.wikipedia.org/wiki/Law_of_total_probability
[wikiMammo]: http://de.wikipedia.org/wiki/Mammographie#Kritik_am_Mammographie-Screening
[KGMC2000]: http://www.ncbi.nlm.nih.gov/pubmed/11002452