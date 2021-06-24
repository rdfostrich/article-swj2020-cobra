## Related Work
{:#related-work}

In this section, we discuss the fundamentals on RDF archiving,
which RDF archiving solutions already exist,
and benchmarks for RDF archiving.
Finally, we discuss OSTRICH in more detail,
since we build upon this approach in this work.

### RDF Archiving

Various techniques have been introduced to store [RDF datasets](cite:cites hdt, rdf3x).
These techniques make use of various indexing and compression techniques
to optimize query execution and storage size.
There is a need to [maintain the history of these datasets](cite:cites datasetdynamics, archiving),
which gave rise to the research domain of *RDF archiving*.
An [_RDF archive_](cite:cites bear) has been defined as _a set of version-annotated triples._
Where a _version-annotated triple_ is defined as _an RDF triple with a label representing the version in which this triple holds._
Furthermore, an RDF version of an RDF archive is composed of all triples with a given version label.

RDF archives allow multiple versions to exist in parallel,
which leads to a range of new querying possibilities.
Instead of only querying within the latest version of a dataset,
also previous versions can be queried,
or even differences between different versions.
To cover this new range of querying possibilities,
[five foundational query types were introduced](cite:cites bear),
which are referred to as _query atoms_.
For brevity, we refer to [the article in which they were introduced](cite:cites bear) their formal details.
In this scope of this article, we only discuss three of the five query atoms,
as they can be expressed in [terms of each other](cite:cites tpfarchives).
The three relevant query atoms are defined as follows:

1. **Version materialization (VM)** retrieves data using a query targeted at a single version.
Example: _Which books were present in the library yesterday?_
2. **Delta materialization (DM)** retrieves query result change sets between two versions.
Example: _Which books were returned or taken from the library between yesterday and now?_
3. **Version query (VQ)** annotates query results with the versions in which they are valid.
Example: _At what times was book X present in the library?_

### RDF Archiving Solutions

In the recent years, several techniques and solutions have been proposed to allow storing and querying RDF archives.
RDF archiving systems are typically categorized into [four non-orthogonal storage strategies](cite:cites archiving, quit):

- The **Independent Copies (IC)** approach creates separate instantiations of datasets for
each change or set of changes.
- The **Change-Based (CB)** approach instead only stores change sets between versions.
- The **Timestamp-Based (TB)** approach stores the temporal validity of facts.
- The **Fragment-based (FB)** approach stores snapshots of each changed _fragment_ of datasets.

There exists a correspondence between these query atoms
and the independent copies (IC), change-based (CB), timestamp-based (TB) and fragment-based (FB) storage strategies.
Namely, IC and FB typically lead to efficient VM queries,
CB is better for DM queries,
and TB is best for VQ queries.
No single strategy leads to good performance of all query atoms.

[](#rdf-archive-systems) shows an overview of the primary RDF archiving systems,
and which storage strategy they follow. These are explained in more detail hereafter.

<figure id="rdf-archive-systems" class="table" markdown="1">

| Name                                            | IC | CB | TB | FB |
| ----------------------------------------------- |----|----|----|----|
| [SemVersion](cite:cites semversion)             | ✓  |    |    |    |
| [Cassidy et al.](cite:cites vcrdf)              |    | ✓  |    |    |
| [R&WBase](cite:cites rwbase)                    |    | ✓  |    |    |
| [R43ples](cite:cites r43ples)                   |    | ✓  |    |    |
| [Hauptman et al.](cite:cites vcld)              |    |    | ✓  |    |
| [X-RDF-3X](cite:cites xrdf3x)                   |    |    | ✓  |    |
| [RDF-TX](cite:cites rdftx)                      |    |    | ✓  |    |
| [v-RDFCSA](cite:cites selfindexingarchives)     |    |    | ✓  |    |
| [Dydra](cite:cites dydra)                       |    |    | ✓  |    |
| [Quit Store](cite:cites quit)                   |    |    |    | ✓  |
| [TailR](cite:cites tailr)                       | ✓  | ✓  |    |    |
| [Cuevas et al.](cite:cites cuevas2020versioned) | ✓  | ✓  | ✓  |    |
| [OSTRICH](cite:cites ostrich)                   | ~  | ✓  | ✓  |    |

<figcaption markdown="block">
Overview of RDF archiving solutions with their corresponding storage strategy:
Individual copies (IC), Change-based (CB), Timestamp-based (TB), or Fragment-based (FB).
✓: fullfils the strategy completely; ~: fullfuls the strategy partially.
</figcaption>
</figure>

#### Independent copies approaches
[SemVersion](cite:cites semversion) tracks different versions of RDF graphs,
using Concurrent Versions System (CVS) concepts to maintain different versions of ontologies,
such as diff, branching and merging.

#### Change-based approaches
[Cassidy et al.](cite:cites vcrdf) propose a system to store changes to graphs as a series of patches, which makes it a CB approach.
They describe operations on versioned graphs such as reverse, revert and merge.
A preliminary evaluation shows that their implementation is significantly slower
than a native RDF store.
[Im et al.](cite:cites vmrdf) propose a CB patching system based on a relational database.
In their approach, they use a storage scheme called *aggregated deltas*
which associates the latest version with each of the previous ones.
While aggregated deltas result in fast delta queries, they introduce a higher storage overhead.
[R&WBase](cite:cites rwbase) is a CB versioning system that uses the graph component of quad-stores to build a versioning layer.
It supports tagging, branching and merging.
[R43ples](cite:cites r43ples) follows a similar approach to R&WBase,
but they additionally introduce new SPARQL keywords, such as `REVISION`, `BRANCH` and `TAG`.

#### Timestamp-based approaches
[Hauptman et al.](cite:cites vcld) store each triple in a different named graph as a TB storage approach.
The identifying graph of each triple is used in a commit graph for SPARQL query evaluation at a certain version.
[X-RDF-3X](cite:cites xrdf3x) is a versioning extension of [RDF-3X](cite:cites rdf3x),
where each triple is annotated with a creation and deletion timestamp.
[RDF-TX](cite:cites rdftx) is an in-memory query engine that supports a temporal SPARQL querying extension,
which makes use of a compressed multi-version B+Trees that outperforms similar systems such as X-RDF-3X in terms of querying efficiency,
while having similar storage requirements.
[v-RDFCSA](cite:cites selfindexingarchives) is a self-indexing RDF archive mechanism,
that enables versioning queries on top of compressed RDF archives as a TB approach.
[Dydra](cite:cites dydra) is an RDF graph storage platform with dataset versioning support.
They introduce the `REVISION` keyword, which is similar to the SPARQL keyword `GRAPH` for referring to different dataset versions.

#### Fragment-based approaches
[Quit Store](cite:cites quit) is a system that is built on top of Git,
which allows these same features by considering each version to be a commit.
A version is made up of multiple fragments, which may be reused across multiple versions of a dataset,
which typically leads to lower storage space compared to a pure IC strategy.
Using Git's delta compression, this storage space can be reduced even further at the cost of slower querying.

#### Hybrid approaches
[TailR](cite:cites tailr) is an HTTP archive for Linked Data pages for retrieving prior versions of certain HTTP resources.
It is a hybrid CB/IC approach as it starts by storing a dataset snapshot,
after which only deltas are stored for each consecutive version.
When the chain becomes too long, or other conditions are fulfilled,
a new snapshot is created for the next version to avoid long version reconstruction times.
[Cuevas et al.](cite:cites cuevas2020versioned) propose an approach similar to R&WBase,
where the named graph functionality in SPARQL 1.1 engines is used to store RDF archives,
and versioned queries are achieved through query rewriting.
As opposed to R&WBase that only uses a CB approach, they propose distinct a IC strategy, four CB strategies, and a TB strategy.
For each of those strategies, they introduce separate query rewriting techniques for VM and DM queries,
but do not consider VQ queries.
Experimental results on an archive with eight large versions show there is a time-space trade-off,
whereby large storage sizes achieve faster query execution,
and smaller storage sizes result in slower query execution.
The authors consider the TB strategy achieving the best trade-off.
Relevant for our work, is the use of four CB strategies,
which correspond to forward, backward deltas, forward [aggregated](cite:cites vmrdf), and backward aggregated deltas.
[OSTRICH](cite:cites ostrich) is a hybrid IC/CB/TB approach that exploits the advantages of each strategy
to provide a trade-off between storage requirements and querying efficiency.
It only fullfils the IC strategy partially,
since it only creates a fully materialized snapshot for the first version,
and stores differences afterwards.
Experiments show that OSTRICH achieves good querying performance for all query atoms,
but suffers from scalability issues in terms of ingestion time for many versions.
As such, we build upon OSTRICH in this work, and attempt to solve this problem.

### RDF Archiving Benchmarks

[BEAR](cite:cites bear) is a benchmark for RDF archive systems.
that is based on real-world datasets from different domains.
The 58 versions of BEAR-A contain between 30M and 66M triples per version, with an average change ratio of 31%.
BEAR-A provides triple pattern queries for three different query atoms for both result sets with a low and a high cardinality.
The BEAR-B dataset contains the 100 most volatile resources from DBpedia Live as three different granularities (instant, hour and day),
and provides a small collection of triple pattern queries corresponding to the real-world usage of DBpedia.
Each version contains between 33K and 43K triples, where the instant granularity has an average change ratio of 0.011%,
hour has 0.304%, and day has 1.252%.
Given the relative number of triples and change ratios between BEAR-A and BEAR-B,
we refer to BEAR-A as a dataset with few large versions,
and to BEAR-B as a dataset with many small versions for the remainder of this article.

The BEAR benchmark also provides baseline RDF archive implementations based on [HDT](cite:cites hdt) and
[Jena's](cite:cites jena) [TDB store](https://jena.apache.org/documentation/tdb/)
for the IC, CB, and TB approaches, and the hybrid IC/CB and TB/CB approaches.
Just like [TailR](cite:cites tailr), the hybrid approaches are based on snapshots followed by delta chains.
Since HDT does not support quads by default, the TB and TB/CB approaches were not implemented in the HDT baseline implementations.
Given the variety of these approaches in terms of storage strategies,
together with their open availability and ease of use,
they form a good basis for comparative analysis when benchmarking,
which is why we make use of them during our experiments.

Due to BEAR covering all query atoms we work with,
and it providing baseline implementations for the different storage strategies,
we make use of BEAR for our experiments.

### OSTRICH

As mentioned before, [OSTRICH](cite:cites ostrich) makes use of a hybrid IC/CB/TB storage approach
with the goal of providing a trade-off between storage size and querying efficiency.
The main motivation for OSTRICH is to serve as a back-end of a [low-cost Web APIs for exposing RDF archives](cite:cites vtpf),
where query execution must be sufficiently fast,
without requiring too much storage.

Concretely, OSTRICH always starts by storing the initial version as a fully materialized version, following the IC strategy.
This initial version is stored using [HDT](cite:cites hdt), which enables high compression and efficient querying.
Based on this initial version, all following versions are stored as deltas, following the CB strategy.
To solve the problem of increasing query execution times for increasing numbers of versions,
OSTRICH makes use of the [aggregated deltas](cite:cites vmrdf) approach,
by making each delta relative to the initial snapshot instead of the previous version.
Due to the storage redundancies that are introduced because of these aggregated deltas,
OSTRICH uses a B+tree-based approach to store all aggregated deltas in a single store.
This single store annotates each added and deleted triple with the delta version in which it exists,
thereby following the timestamp-based strategy.
To further reduce storage requirements and query execution times,
all triple components inside this store are dictionary-encoded, similar to the approach followed by HDT.

On top of this storage approach, OSTRICH introduces algorithms for VM, DM and VQ triple pattern queries.
Only triple pattern queries are supported instead of full SPARQL queries,
since triple pattern queries are the foundational building blocks for more expressive SPARQL queries.
These query algorithms produce streaming results, where the streams can start from an arbitrary offset,
which is valuable for SPARQL query features such as `OFFSET` and `LIMIT`.
Additionally, OSTRICH provides algorithms for cardinality estimation for these queries,
which are valuable for query planning within query engines.
OSTRICH has been implemented in [C/C++](https://github.com/rdfostrich/ostrich),
with bindings existing for [Node.JS (JavaScript)](https://github.com/rdfostrich/ostrich-node).
The triple pattern index provided by OSTRICH has been demonstrated
to be usable within a full SPARQL query engine such as [Comunica](cite:cites comunica,ostrich_comunica).

Experimental results on OSTRICH with the BEAR benchmark show that this hybrid strategy
is more beneficial than having just a single storage strategy,
as it allows efficient execution of all query atoms.
The main downside of this approach is that it leads to scalability issues in terms of ingestion time for many versions.
Concretely, the BEAR-B-hourly dataset—which contains 1,299 versions—
starts showing high ingestion times starting around version 1,100.
The reason for this is that the aggregated deltas start becoming too large.
As such, we aim to resolve this problem in this work by improving the hybrid storage strategy from OSTRICH
through fundamental changes to the delta chain structure.
