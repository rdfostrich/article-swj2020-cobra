## Introduction
{:#introduction}

Even though the [RDF](cite:cites spec:rdf) data model itself is atemporal,
RDF datasets typically [change over time](cite:cites datasetdynamics).
Such changes can include additions,
modifications, or deletions of complete datasets, ontologies, and separate facts.
While some evolving datasets, such as [DBpedia](cite:cites dbpedia),
are published as separate dumps per version,
more direct and efficient access to prior versions is desired.

While RDF archiving systems have emerged that can handle such evolving datasets,
[a recent survey on archiving Linked Open Data](cite:cites archiving)
illustrated the need for improved versioning capabilities.
Concretely, there is a need for systems that can store and query such datasets on average Web servers,
without requiring expensive high-end machines.
Recently, a [new archiving approach (OSTRICH)](cite:cites ostrich) was introduced
that offers highly efficient triple pattern queries for different versioned query types,
while still keeping storage requirements reasonable.
OSTRICH was designed to run on average machines,
so it can be used as a back-end for low-cost Web query interfaces such as [Triple Pattern Fragments](cite:cites ldf).
Since OSTRICH exposes a triple pattern query interface,
it can also be used as an index inside [SPARQL query engines](cite:cites spec:sparqllang).

The main problem of OSTRICH is that it suffers from scalability issues during ingestion,
which are caused by its hybrid storage strategy that is followed to achieve performant query execution.
Concretely, after ingesting many versions, the ingestion process starts slowing down significantly,
which makes OSTRICH unusable for datasets with a large number of versions.
The reason for this is that the hybrid storage approach from OSTRICH consists of a single version _snapshot_
followed by a _aggregated delta chain_ that keeps growing longer for every new version.
Since every additional delta requires all preceding deltas to be checked during ingestion,
this process becomes slower for every new version.
In order to solve this problem, we propose a storage strategy modification,
where there still is a single version snapshot,
but we place it in the middle of the delta chain,
instead of at the beginning,
leading to a _bidirectional delta chain_.
While this complicates ingestion and querying,
it leads to two shorter delta chains,
which will require less effort than one long delta chain.

In the next section, we discuss the related work,
and give more details on OSTRICH.
Next, in [](#problem-statement), we present our problem statement,
followed by our proposed solution in [](#solution).
After that, we present our experimental setup and results in [](#evaluation),
and we conclude in [](#conclusions).
