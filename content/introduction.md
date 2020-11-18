## Introduction
{:#introduction}

Even though the [RDF](cite:cites spec:rdf) data model itself is atemporal,
RDF datasets typically [change over time](cite:cites datasetdynamics).
Such changes can include additions,
modifications, or deletions of individual facts, ontologies, or even complete datasets.
While some evolving datasets such as [DBpedia](cite:cites dbpedia)
are published as separate dumps per version,
more direct and efficient access to prior versions is desired,
so that versioned queries in, between, and across different versions can be done efficiently.

While RDF archiving systems have emerged in the past that can handle such evolving datasets,
[a survey on archiving Linked Open Data](cite:cites archiving)
illustrated the need for improved versioning capabilities
in order to preserve RDF on the Web and expose queryable access.
Concretely, there is a need for systems that can store and query such datasets with low cost and effort on Web servers,
so that they can cope with the large scale of RDF datasets on the Web, and their velocity.
In previous work, we introduced a [new archiving approach called OSTRICH](cite:cites ostrich)
that offers efficient triple pattern queries for different versioned query types,
while still keeping storage requirements reasonable.
OSTRICH was designed to run on average machines,
so it can be used as a back-end for low-cost Web query interfaces such as [Triple Pattern Fragments](cite:cites ldf).
Since OSTRICH exposes a triple pattern query interface,
it can also be used as an index inside [SPARQL query engines](cite:cites spec:sparqllang).
As such, OSTRICH is a step towards solving the need for properly preserving RDF on the Web.

[A recent survey](cite:cites towardsfullyfledgedarchiving)
has shown that existing RDF archiving solutions fail to handle large RDF archives with many versions.
It was shown that the hybrid approach employed by OSTRICH is the only one capable of storing large RDF archives,
but that it suffers from a scalability issue in terms of ingestion time for many versions.
This are caused by the hybrid storage strategy of OSTRICH, which is employed to achieve performant query execution.
Concretely, after ingesting many versions, the ingestion process starts slowing down significantly,
which makes OSTRICH unusable for datasets with a large number of versions,
which is crucial for preserving RDF datasets on the Web.
The reason for this is that the hybrid storage approach from OSTRICH only consists of a single version _snapshot_ at the start,
followed by an _aggregated delta chain_ that keeps growing longer for every new version.
Since every additional delta requires all preceding deltas to be checked during ingestion,
this process becomes slower for every new version.
In order to solve this problem, we propose a storage strategy modification,
where there still is a single version snapshot,
but we place it in the middle of the delta chain,
instead of at the beginning,
leading to a _bidirectional delta chain_.
While this complicates ingestion and querying,
it leads to two shorter delta chains.
This will require less effort than one long delta chain,
and lead to faster ingestion and querying.

In the next section, we discuss the related work,
and give more details on OSTRICH.
Next, in [](#problem-statement), we present our problem statement,
followed by our proposed solution in [](#solution).
After that, we present our experimental setup and results in [](#evaluation),
and we conclude in [](#conclusions).
