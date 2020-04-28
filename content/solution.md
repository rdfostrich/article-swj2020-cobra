## Bidirectional Delta Chain
{:#solution}

In this section, we explain our bidirectional delta chain approach.
We start by explaining the general idea behind a bidirectional delta chain.
After that, we explain its implication on storage.
Finally, we discuss querying algorithms for the foundational query atoms based on this storage approach.

### Delta Chain Approaches
{:#solution-approaches}

In the scope of this work, we distinguish between six different delta chain approaches,
as can be seen in [](#delta-chain-approaches).
We decompose these approaches into 2 axes: directionality and aggregation.

In terms of directionality, we distinguish three forms.
The simplest form is the *forward unidirectional* delta chain,
where the snapshot comes first, and is followed by deltas that are relative to the previous delta.
The *reverse unidirectional* delta chain is a variant of this where everything is reversed.
Concretely, the snapshot comes last, and is preceded by deltas, where each delta is relative to the next delta.
These forward and reverse unidirectional approaches can be combined with each other to form a *bidirectional delta chain*,
where a first set of deltas exist before the snapshot,
and a second set of deltas exists after the snapshot.

In terms of aggregation, we consider the default non-aggregated form and the aggregated form.
In the non-aggregated form, each delta is relative to the delta immediately before or after it.
In the [aggregated form](cite:cites vmrdf), each delta is relative to the snapshot before or after it,
where other deltas may occur inbetween.
This aggregated delta approach leads to lower version materialization times,
since each delta can be directly applied to a snapshot,
as opposed to non-aggregated deltas where multiple deltas need to be combined before a version can be materialized.
As such, the version materialization time for aggregated deltas is `O(1)` with respect to the number of versions,
while it is `O(n)` for non-aggregated deltas with respect to the number of versions.
This shows how aggregated deltas lead to better query execution times.
The major downside of aggregated deltas is however that storage size increases due to the redundancies between the different deltas.
The longer the delta chain, the larger these redundancies become.

In the context of this work,
OSTRICH is an example that follows the unidirectional forward aggregated delta chain approach,
while RCS follows the unidirectional reverse non-aggregated delta chain approach.
In this work, we will make use of the bidirectional aggregated delta chain approach,
which we will explain in the next section.

<figure id="delta-chain-approaches" class="table" markdown="1">

|  | **Non-aggregated** | **Aggregated** |
|--|----------------|------------|
| **Forward Unidirectional** | <img src="img/delta-chain-uni.svg" alt="Unidirectional delta chain" class="delta-approach"> | <img src="img/delta-chain-uni-agg.svg" alt="Unidirectional aggregated delta chain" class="delta-approach"> |
| **Reverse Unidirectional** | <img src="img/delta-chain-uni-rev.svg" alt="Unidirectional reverse delta chain" class="delta-approach"> | <img src="img/delta-chain-uni-agg-rev.svg" alt="Unidirectional aggregated reverse delta chain" class="delta-approach"> |
| **Bidirectional**          | <img src="img/delta-chain-bi.svg" alt="Bidirectional delta chain" class="delta-approach"> | <img src="img/delta-chain-bi-agg.svg" alt="Bidirectional aggregated delta chain" class="delta-approach"> |
{:.delta-approaches}

<figcaption markdown="block">
Overview of unidirectional forward, unidirectional reverse, and bidirectional delta chain approaches,
both with and without aggregated deltas.
</figcaption>
</figure>

### Motivations for a Bidirectional Delta Chain
{:#solution-bidirectional}

[Experiments on the unidirectional forward aggregated delta chain approach from OSTRICH](cite:cites ostrich)
have shown that this approach leads to linearly increasing ingestion times,
the longer the chain becomes.
This is an expected consequence of the aggregated delta approach,
as they grow in size for each new version.

The goal of this work is to investigate how these problems can be solved,
without losing the advantages of aggregated deltas with respect to query execution times.
As such, we will not achieve any lower ingestion times by reversing our delta chain,
as the additions and deletions would simply be reversed,
without reducing size and effort.

One straightforward way of reducing ingestion time would be
to create a new snapshot and delta chain once the ingestion time or size becomes too large.
For instance, we can lower the total ingestion time to half the original time
by splitting one delta chain into two delta chains,
or even to one third by splitting it up into three delta chains.
In the extreme, each version would be form its own snapshot,
which would lead to the independent copies storage strategy,
at the cost of increased storage size.
As such, there is a trade-off between ingestion time and storage size,
and new delta chains should only be started once ingestion times become much higher than desired.

Since the creation of a snapshot can be costly, it should be avoided until absolutely necessary.
As explained in the last paragraph,
splitting up a delta chain into two separate delta chains
would lead to two snapshots, each followed by a chain of deltas.
We can however reduce the number of required snapshots
by combining the forward and reverse approaches into a *bidirectional* approach,
by allowing two sets of deltas to make use of the same snapshot.
Intuitively, a bidirectional delta chain is equivalent
to two forward delta chains,
where the second delta chain is reversed,
and the snapshots of these two chains are therefore shared,
so that it only has to be created and stored once.

As such, the main advantage of a bidirectional delta chain is that it can more optimally make use of the snapshot.
Instead of only allowing deltas in one direction to make use of it,
also deltas in the opposite direction can make use of it.
This especially is advantageous for aggregated deltas,
as these grow in size for longer chains.
In the scope of this research,
we continue working with a bidirectional aggregated delta chain
due to the non-increasing query execution times for increasing numbers of versions.

### Storage Approach
{:#solution-storage}

Write me
{:.todo}

### Ingestion Algorithm
{:#solution-ingestion}

Write me
{:.todo}

### Query Algorithms
{:#solution-query}

Write me
{:.todo}

