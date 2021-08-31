## Abstract
<!-- Context      -->
Linked Open Datasets on the Web that are published as RDF can evolve over time.
There is a need to be able to store such evolving RDF datasets,
and query across their versions.
Different storage strategies are available for managing such versioned datasets,
each being efficient for specific types of versioned queries.
In recent work, a hybrid storage strategy has been introduced that combines these different strategies
to lead to more efficient query execution for all versioned query types at the cost of increased ingestion time.
While this trade-off is beneficial in the context of Web querying,
it suffers from exponential ingestion times in terms of the number of versions,
which becomes problematic for RDF datasets with many versions.
<!-- Need         -->
As such, there is a need for an improved storage strategy that scales better in terms of ingestion time for many versions.
<!-- Task         -->
We have designed, implemented, and evaluated a change to the hybrid storage strategy
where we make use of a _bidirectional delta chain_
instead of the default _unidirectional delta chain_.
<!-- Object       -->
In this article,
we introduce a concrete architecture for this change,
together with accompanying ingestion and querying algorithms.
<!-- Findings     -->
Experimental results from our implementation
show that the ingestion time is significantly reduced.
As an additional benefit,
this change also leads to lower total storage size and even improved query execution performance in some cases.
<!-- Conclusion   -->
This work shows that modifying the structure of delta chains within the hybrid storage strategy
can be highly beneficial for RDF archives.
<!-- Perspectives -->
In future work,
other modifications to this delta chain structure deserve to be investigated,
to further improve the scalability of ingestion and querying of datasets with many versions.

<span id="keywords"><span class="title">Keywords:</span> Linked Data, RDF archiving, Semantic Data Versioning, storage, indexing</span>
