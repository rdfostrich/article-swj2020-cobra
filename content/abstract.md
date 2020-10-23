## Abstract
<!-- Context      -->
In a Web where RDF datasets are continuously evolving,
the ability to store and query multiple RDF dataset versions is crucial.
<span class="comment" data-author="RV">The implication is not correct. It's not because they evolve, that we necessarily have an interest in history. I'd motivate that. However, we are likely talking to a group of people who are already convinced about the necessity of history, so maybe we can just take it as a given and not make the point at all (if it would take too much space).</span>
While the hybrid storage strategy of RDF archives achieves a good trade-off
<span class="comment" data-author="RV">Not sure people will now what <q>the hybrid</q> is</span>
between ingestion and query performance in the context of Web querying,
it suffers from scalability problems after ingesting many versions.
<span class="comment" data-author="RV">Scalability in terms of what? Ingestion time, space?</span>
<!-- Need         -->
As such, there is a need for an improved storage strategy that scales better in terms of ingestion time.
<span class="comment" data-author="RV">While I buy the argument, can we be stronger? Why is ingestion time a problem? Because updates are coming in faster than we can process them? Because the delay between update and queryable interface is too long?</span>
<!-- Task         -->
We have designed, implemented, and evaluated a change to the hybrid storage strategy
where we make use of of _bidirectional delta chain_
instead of the default _unidirectional delta chain_.
<!-- Object       -->
In this article,
we introduce a concrete architecture for this change,
together with accompanying ingestion and querying algorithms.
<!-- Findings     -->
Experimental results from our implementation
show that the ingestion scalability issue is solved,
and that total storage size and query execution performance
are even improved for most cases.
<span class="comment" data-author="RV"><q>even</q>, so this was unexpected? If that was indeed a difficulty, perhaps argue this in need, showing why the need is non-trivial.</span>
<!-- Conclusion   -->
This work shows that modifying the structure of the delta chain within the hybrid storage strategy
can be highly beneficial for RDF archives.
<!-- Perspectives -->
We foresee that applying other modifications to this delta chain structure
may be able to provide additional benefits.
<span class="comment" data-author="RV">A bit more concrete please 😄</span>

<span id="keywords"><span class="title">Keywords:</span> Linked Data, RDF archiving, Semantic Data Versioning, storage, indexing</span>
