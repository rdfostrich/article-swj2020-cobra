## Introduction
{:#introduction}

Even though the [RDF](cite:cites spec:rdf) data model itself is atemporal,
RDF datasets typically [change over time](cite:cites datasetdynamics).
Such changes can include additions,
modifications, or deletions of individual facts, ontologies, or even complete datasets.
While some evolving datasets such as [DBpedia](cite:cites dbpedia)
are published as separate dumps per version,
more direct and efficient access to prior versions is desired.
<span class="comment" data-author="RV">But why? I think we really need to make the point here. Not just as justification, but also to explain what kind of problems are currently pressing and why. Is ingestion time a bottleneck? Storage space?</span>

While RDF archiving systems have emerged that can handle such evolving datasets,
[a recent survey on archiving Linked Open Data](cite:cites archiving)
illustrated the need for improved versioning capabilities.
  <span class="comment" data-author="RV">Ah okay! Can we briefly re-iterate their main arguments here?</span>
  Concretely, there is a need for systems that can store and query such datasets on average Web servers,
  without requiring expensive high-end machines.
  <span class="comment" data-author="RV">Yeah, but where does the need come from? It's important to understand, such that we can also understand any non-functional requirements from that use case (such as the mentioned low machine cost).</span>
  In previous work, we introduced a [new archiving approach called OSTRICH](cite:cites ostrich)
  that offers efficient triple pattern queries for different versioned query types,
while still keeping storage requirements reasonable.
OSTRICH was designed to run on average machines,
so it can be used as a back-end for low-cost Web query interfaces such as [Triple Pattern Fragments](cite:cites ldf).
Since OSTRICH exposes a triple pattern query interface,
it can also be used as an index inside [SPARQL query engines](cite:cites spec:sparqllang).

<span class="comment" data-author="RV">So just be be clear: OSTRICH is or is not an answer to the earlier cited need? Let's be explicit, that will help the next paragraph.</span>

The main problem of OSTRICH is that it suffers from scalability issues during ingestion,
which are caused by its hybrid storage strategy that is followed to achieve performant query execution.
Concretely, after ingesting many versions, the ingestion process starts slowing down significantly,
which makes OSTRICH unusable for datasets with a large number of versions.
<span class="comment" data-author="RV">So now refer back to the needs.</span>
The reason for this is that the hybrid storage approach from OSTRICH consists of a single version _snapshot_
followed by a _aggregated delta chain_ that keeps growing longer for every new version.
<span class="comment" data-author="RV">This wrongly reads as if there is only one snapshot for an entire dataset, whereas there are multiple.</span>
Since every additional delta requires all preceding deltas to be checked during ingestion,
this process becomes slower for every new version.
<span class="comment" data-author="RV">Can we make the argument here that, somewhere between snapshots A and B, a single version could resemble B more closely than A?</span>
In order to solve this problem, we propose a storage strategy modification,
where there still is a single version snapshot,
but we place it in the middle of the delta chain,
instead of at the beginning,
leading to a _bidirectional delta chain_.
<span class="comment" data-author="RV">Ah interesting, you visualize it as putting the snapshot in the middle, whereas I visualize it as versions getting a different parent. I'm leaving my comment so you can think which narrative is the clearest one (but also in the context of their being multiple snapshots, which is what I was missing initially).</span>
While this complicates ingestion and querying,
it leads to two shorter delta chains,
which will require less effort than one long delta chain.
<span class="comment" data-author="RV">So more complicated but faster ingestion? Can we say that explicitly?</span>

In the next section, we discuss the related work,
and give more details on OSTRICH.
Next, in [](#problem-statement), we present our problem statement,
followed by our proposed solution in [](#solution).
After that, we present our experimental setup and results in [](#evaluation),
and we conclude in [](#conclusions).
