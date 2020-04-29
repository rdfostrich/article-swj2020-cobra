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
Since RDF datasets typically [change over time](cite:cites datasetdynamics),
there is a need to [maintain the history of these datasets](cite:cites archiving),
which gave rise to the research domain of *RDF archiving*.

An [_RDF archive_](cite:cites bear) has been defined as follows:
_An RDF archive graph A is a set of version-annotated triples._
Where a _version-annotated triple_ _(s, p, o):\[i\]_ is defined as _an RDF triple (s, p, o) with a label i ∈ N representing the version in which this triple holds._
The set of all [RDF triples](cite:cites spec:rdf) is defined as _(U ∪ B) × U × (U ∪ B ∪ L)_,
where _U_, _B_, and _L_, respectively represent the disjoint, infinite sets of URIs, blank nodes, and literals.
Furthermore,
_an RDF version of an RDF archive A at snapshot i is the RDF graph A(i) = {(s, p, o)|(s, p, o):\[i\] ∈ A}._
For the remainder of this article, we use the notation _V<sub>i</sub>_ to refer to the RDF version _A(i)_.

RDF archives allow multiple versions to exist in parallel,
which leads to a range of new querying possibilities.
Instead of only querying within the latest version of a dataset,
also previous versions can be queried,
or even differences between different versions.
To cover this new range of querying possibilities,
[five foundational query types were introduced](cite:cites bear),
which are referred to as _query atoms_.
These query atoms make use of concepts from the
the [RDF data model](cite:cites spec:rdf) and [SPARQL query language](cite:cites spec:sparqllang).
In these models, a _triple pattern_ is defined as _(U ∪ V) × (U ∪ V) × (U ∪ L ∪ V)_, with _V_ being the infinite set of variables.
A set of triple patterns is called a _Basic Graph Pattern_, which forms the basis of a SPARQL query.
The evaluation of a SPARQL query _Q_ on an RDF graph _G_ containing RDF triples,
produces a bag of solution mappings _\[\[Q\]\]<sub>G</sub>_.
The five query atoms are defined as follows:

1. **Version materialization (VM)** retrieves data using a query _Q_ targeted at a single version _V<sub>i</sub>_.
Formally: _VM(Q, V<sub>i</sub>) = \[\[Q\]\]<sub>V<sub>i</sub></sub>_.
Example: _Which books were present in the library yesterday?_
2. **Delta materialization (DM)** retrieves query _Q_'s result change sets between two versions _V<sub>i</sub>_ and _V<sub>j</sub>_.
Formally: _DM(Q, V<sub>i</sub>, V<sub>j</sub>)=(Ω<sup>+</sup>, Ω<sup>−</sup>). With Ω<sup>+</sup> = \[\[Q\]\]<sub>V<sub>i</sub></sub> \ \[\[Q\]\]<sub>V<sub>j</sub></sub> and Ω<sup>−</sup> = \[\[Q\]\]<sub>V<sub>j</sub></sub> \ \[\[Q\]\]<sub>V<sub>i</sub></sub>_.
Example: _Which books were returned or taken from the library between yesterday and now?_
3. **Version query (VQ)** annotates query _Q_'s results with the versions (of RDF archive A) in which they are valid.
Formally: _VQ(Q, A) = {(Ω, W) | W = {A(i) | Ω=\[\[Q\]\]<sub>A(i)</sub>, i ∈ N} ∧ Ω ≠ ∅}_.
Example: _At what times was book X present in the library?_
4. **Cross-version join (CV)** joins the results of two queries (_Q1_ and _Q2_) between versions _V<sub>i</sub>_ and _V<sub>j</sub>_.
Formally: _VM(Q1, V<sub>i</sub>) ⨝ VM(Q2, V<sub>j</sub>)_.
Example: _What books were present in the library yesterday and today?_
5. **Change materialization (CM)** returns a list of versions in which a given query _Q_ produces
consecutively different results.
Formally: _{(i, j) | i,j ∈ ℕ, i < j, DM(Q, A(i), A(j)) = (Ω<sup>+</sup>, Ω<sup>−</sup>), Ω<sup>+</sup> ∪ Ω<sup>−</sup> ≠ ∅, ∄ k ∈ ℕ : i < k < j}_.
Example: _At what times was book X returned or taken from the library?_

In the remainder of this article, we focus on version materialization (VM), delta materialization (DM), and version (VQ) queries,
as CV and CM queries can be expressed in [terms of the other ones](cite:cites tpfarchives).

### RDF Archiving Solutions

In the recent years, several techniques and solutions have been proposed to allow storing and querying RDF archives.
RDF archiving systems are typically categorized into [three non-orthogonal storage strategies](cite:cites archiving):

- The **Independent Copies (IC)** approach creates separate instantiations of datasets for
each change or set of changes.
- The **Change-Based (CB)** approach instead only stores change sets between versions.
- The **Timestamp-Based (TB)** approach stores the temporal validity of facts.

There exists a correspondence between these query atoms
and the independent copies (IC), change-based (CB), and timestamp-based (TB) storage strategies.
Namely, IC typically leads to efficient VM queries,
CB is better for DM queries,
and TB is best for VQ queries.
No single strategy leads to good performance of all query atoms.

[](#rdf-archive-systems) shows an overview of the primary RDF archiving systems,
and which storage strategy they follow.

<figure id="rdf-archive-systems" class="table" markdown="1">

| Name                                        | IC | CB | TB |
| ------------------------------------------- |----|----|----|
| [SemVersion](cite:cites semversion)         | ✓  |    |    |
| [Cassidy et. al.](cite:cites vcrdf)         |    | ✓  |    |
| [R&WBase](cite:cites rwbase)                |    | ✓  |    |
| [R43ples](cite:cites r43ples)               |    | ✓  |    |
| [Hauptman et. al.](cite:cites vcld)         |    |    | ✓  |
| [X-RDF-3X](cite:cites xrdf3x)               |    |    | ✓  |
| [RDF-TX](cite:cites rdftx)                  |    |    | ✓  |
| [v-RDFCSA](cite:cites selfindexingarchives) |    |    | ✓  |
| [Dydra](cite:cites dydra)                   |    |    | ✓  |
| [Quit Store](cite:cites quit)               | ✓  |    |    |
| [TailR](cite:cites tailr)                   | ✓  | ✓  |    |
| [OSTRICH](cite:cites ostrich)               | ✓  | ✓  | ✓  |

<figcaption markdown="block">
Overview of RDF archiving solutions with their corresponding storage strategy:
Individual copies (IC), Change-based (CB), or Timestamp-based (TB).
</figcaption>
</figure>

#### Independent copies approaches
[SemVersion](cite:cites semversion) tracks different versions of RDF graphs,
using Concurrent Versions System (CVS) concepts to maintain different versions of ontologies,
such as diff, branching and merging.
[Quit Store](cite:cites quit) is a system that is built on top of Git,
which allows these same features by considering each version to be a commit.

#### Change-based approaches
[Cassidy et. al.](cite:cites vcrdf) propose a system to store changes to graphs as a series of patches, which makes it a CB approach.
They describe operations on versioned graphs such as reverse, revert and merge.
A preliminary evaluation shows that their implementation is significantly slower
than a native RDF store.
[Im et. al.](cite:cites vmrdf) propose a CB patching system based on a relational database.
In their approach, they use a storage scheme called *aggregated deltas*
which associates the latest version with each of the previous ones.
While aggregated deltas result in fast delta queries, they introduce a higher storage overhead.
[R&WBase](cite:cites rwbase) is a CB versioning system that uses the graph component of quad-stores to build a versioning layer.
It supports tagging, branching and merging.
[R43ples](cite:cites r43ples) follows a similar approach to R&WBase,
but they additionally introduce new SPARQL keywords, such as REVISION, BRANCH and TAG.

#### Timestamp-based approaches
[Hauptman et. al.](cite:cites vcld) store each triple in a different named graph as a TB storage approach.
The identifying graph of each triple is used in a commit graph for SPARQL query evaluation at a certain version.
[X-RDF-3X](cite:cites xrdf3x) is a versioning extension of [RDF-3X](cite:cites rdf3x),
where each triple is annotated with a creation and deletion timestamp.
[RDF-TX](cite:cites rdftx) is an in-memory query engine that supports a temporal SPARQL querying extension,
which makes use of a compressed multi-version B+Trees that outperforms similar systems such as X-RDF-3X in terms of querying efficiency,
while having similar storage requirements.
[v-RDFCSA](cite:cites selfindexingarchives) is a self-indexing RDF archive mechanism,
that enables versioning queries on top of compressed RDF archives as a TB approach.
[Dydra](cite:cites dydra) is an RDF graph storage platform with dataset versioning support.
They introduce the REVISION keyword, which is similar to the GRAPH SPARQL keyword for referring to different dataset versions.

#### Hybrid approaches
[TailR](cite:cites tailr) is an HTTP archive for Linked Data pages for retrieving prior versions of certain HTTP resources.
It is a hybrid CB/IC approach as it starts by storing a dataset snapshot,
after which only deltas are stored for each consecutive version, as shown in [](#regular-delta-chain).
When the chain becomes too long, or other conditions are fulfilled,
a new snapshot is created for the next version to avoid long version reconstruction times.
[OSTRICH](cite:cites ostrich) is a hybrid IC/CB/TB approach that exploits the advantages of each strategy
to provide a trade-off between storage requirements and querying efficiency.
Experiments show that OSTRICH achieves good querying performance for all query atoms,
but suffers from scalability issues in terms of ingestion time for many versions.
As such, we build upon OSTRICH in this work, and attempt to solve this problem.

### RDF Archiving Benchmarks

[BEAR](cite:cites bear) is a benchmark for RDF archive systems.
that is based on three real-world datasets from different domains:

BEAR-A
: 58 weekly snapshots from the [Dynamic Linked Data Observatory](cite:cites datasetdynamics).

BEAR-B
: The 100 most volatile resources from [DBpedia Live](cite:cites dbpedialive) over the course of three months
as three different granularities: instant, hour and day.

BEAR-C
: Dataset descriptions from the [Open Data Portal Watch](cite:cites opendataportalwatch) project over the course of 32 weeks.

The 58 versions of BEAR-A contain between 30M and 66M triples per version, with an average change ratio of 31%.
BEAR-A provides triple pattern queries for three different query atoms for both result sets with a low and a high cardinality.
BEAR-B provides a small collection of triple pattern queries corresponding to the real-world usage of DBpedia.
Finally, BEAR-C provides 10 complex SPARQL queries that were created with the help of Open Data experts.

BEAR provides baseline RDF archive implementations based on [HDT](cite:cites hdt) and [Jena](cite:cites jena)
for the IC, CB, and TB approaches, but also hybrid IC/CB and TB/CB approaches.
The hybrid approaches are based on snapshots followed by delta chains, as implemented by [TailR](cite:cites tailr).

Due to BEAR covering all query atoms we work with,
and it providing baseline implementations for the different storage strategies,
we make use of BEAR for our experiments.

### OSTRICH

As mentioned before, [OSTRICH](cite:cites ostrich) make us of a hybrid IC/CB/TB storage approach
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
to be usable within a full SPARQL query engine such as [Comunica](cite:cites ostrich_comunica,comunica).

Experimental results on OSTRICH with the BEAR benchmark show that this hybrid strategy
is more beneficial than having just a single storage strategy,
as it allows efficient execution of all query atoms.
The main downside of this approach is that it leads to scalability issues in terms of ingestion time for many versions.
Concretely, the BEAR-B-hourly dataset—which contains 1299 versions—
starts showing high ingestion times starting around version 1100.
The reason for this is that the aggregated deltas start becoming too large.
As such, we build upon OSTRICH in this work, and attempt to solve this problem by modifying the delta chain structure.
