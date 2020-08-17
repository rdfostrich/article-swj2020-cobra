## Abstract
<!-- Context      -->
In a Web where RDF datasets are continuously evolving,
the ability to store and query multiple RDF dataset versions is crucial.
While the hybrid storage strategy of RDF archives is able to achieve a good trade-off
between ingestion and query performance in the context of Web querying,
it suffers from scalability problems after ingesting many versions.
<!-- Need         -->
As such, there is a need for an improved storage strategy that scales better in terms of ingestion time.
<!-- Task         -->
In this article, we propose a change to the hybrid storage strategy
where we make use of of _bidirectional delta chain_
instead of the default _unidirectional delta chain_.
<!-- Object       -->
We introduce a concrete architecture for this change,
together with accompanying ingestion and querying algorithms.
<!-- Findings     -->
Based on our implementation of this new approach,
experimental results show that the ingestion scalability issue is solved,
and that total storage size and query execution performance
are even improved for most cases.
<!-- Conclusion   -->
This work shows that modifying the structure of the delta chain within the hybrid storage strategy
can be highly beneficial for RDF archives.
<!-- Perspectives -->
We foresee that applying other modifications to this delta chain structure
may be able to provide additional benefits.

<span id="keywords"><span class="title">Keywords:</span> Linked Data, RDF archiving, Semantic Data Versioning, storage, indexing</span>
