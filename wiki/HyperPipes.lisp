<p><a href="http://menzies.us/iccle/?refs#Eisenstein04">[Eisenstein04]</a> offer an empirical
evaluation of TWCNB and a very simple alternative called <em>hyperpipes</em>. And it works
so well that it is worthy of exploration.

<p>Here's the official blurb:
<ul>
<li>For each class, a HyperPipe is constructed that contains all points of that class 
(essentially records the attribute bounds observed for each category). 
Test instances are classified according to the class that "most contains the instance".
<li>
Does not handle numeric class, or missing values in test cases.
<li> Extremely simple algorithm.
<li>has the advantage of being extremely fast, and works quite well when you have "smegloads" of attributes.
</ul>

<p>Here's the pseudo code (and for the full story, in JAVA, see
<a href="http://www.java2s.com/Open-Source/Java-Document/Science/weka/weka/classifiers/misc/HyperPipes.java.htm">here</a>:


<pre><code>function train() {
   klass = $Klass   # get the class attribute
   Klasses[k] = 1     # remember we have one more class
   for(i=1;i<=Attr;i++)
     value=$i;
     if (i != Klass)
      if (value !~ /\?/)
         if (numericp(i) {
	       if (value > Max[klass,i]) Max[klass,i]= value
	       if (value < Min[klass,i]) Min[klass,i]= value
        } else { Seen[klass,i,value]= 1 }
} 
</code></pre>

<p>An instance is "contained" if its "<em>i-th</em>"
value overlaps with the ranges seen during testing.

<pre>function contains(klass,i,value) {
     if (numericp(i) { 
         if ((Max[klass,i] >= value) && (Min[klass,i] <= value))
              return 1
      } else { if (Seen[klass,i,value]) 
                 return 1 }
     return 0
}</pre>
<p>During testing, an instance is assigned the class that
is most "contained".
<pre>function mostContained() {
   best = -1;
   for(klass in Klasses) {
      count=0;
      for(i=1;i<=Attr;i++) {
	  value=$i
         if (i != Klass)
            if ( value !~ /\?/ )
               count += contains(klass,i,value)
      count = count / (Attr - 1)
      if ( count >= best ) { 
            best = count; what=klass }
   }
   return what
}
</pre>

<p>That's it. No counting to very large numbers (you are either in 
range, or you are out). No discretization. No handling low
frequency counts, etc.

<p><a href="http://menzies.us/iccle/?refs#Eisenstein04">[Eisenstein04]</a> report a study
where some motion capture tools watched humans discussing diagrams on the whiteboard.
The motion capture software turned their gestures into thousands of features and the resulting
data set had more columns than rows (lots of blank cells).
<p>For this application with <em>smegloads</em> of attributes, HyperPipes did very well indeed 
(10-way cross-val results:)

<pre>

Method         Accuracy sigma
-----------    -------- ----- 
HyperPipes     65.9%    1.47 
TWCNB          63.5%    1.66 
Naive Bayes    58.9%    1.10 
C4.5           56.0%    2.17  <== decision trees
SVM            55.9%    2.17 
Always deictic 48.7%    N/A  <== just return majority class 
</pre>

<p>Why? Well, this algorithm just checks for the presence or absence of a value in a range.
For data sets where most of the rows are full, then this won't work (since a range can be
present in may rows). But for very sparse data, this very very very method works just fine.
<p>And the lesson of this story? Well:

<ul>
<li>Sometimes, less is more
<li>Any statement that "learner X is best" is trite, unless it speaks to the data space
the learner runs over. Hyperpipes fails badly on non-sparse data sets. But on very
sparse data sets, it seems like a useful tool.
</ul>

