## Problem Statement
{:#problem-statement}

As mentioned in [](#introduction), RDF archiving solutions suffer are not sufficiently capable of handing large RDF archives with many versions.
While the hybrid storage approach as proposed by OSTRICH can handle the largest archives among all existing approaches,
it does not scale sufficiently to a large number of versions due to its long delta chains.
Our goal in this work is to investigate if we can build on top of this hybrid storage approach
and modify its delta chain structure
to be able to handle RDF archives with more versions.

We formulate our research question as follows:
<q id="research-question">How can we improve the storage of RDF archives under the hybrid storage strategy by modification of the delta chain structure?</q>

Concretely, we start from the hybrid storage approach from OSTRICH,
and we modify its current (forward) *unidirectional delta chain* (UDC) into a *bidirectional delta chain* (BDC).
This bidirectional delta chain consists of two smaller delta chains,
with respectively reverse and forward deltas, all pointing to one common intermediary snapshot.
Since these modifications will reduce the maximum length of a delta chain, without requiring more snapshots,
we expect that this will reduce ingestion time, overall storage size, and query execution time for all query atoms.
Under the assumption of typical RDF archives provided by standard RDF archiving benchmarks,
we define the following hypotheses:

1. {:#hypothesis-qualitative-storage}
Storage size is lower for a BDC compared to a UDC.
2. {:#hypothesis-qualitative-ingestion}
In-order ingestion time is lower for a BDC compared to a UDC.
3. {:#hypothesis-qualitative-querying-vm}
VM query execution is faster for a BDC compared to a UDC.
4. {:#hypothesis-qualitative-querying-dm}
DM query execution is faster for a BDC to a UDC.
5. {:#hypothesis-qualitative-querying-vq}
VQ query execution is faster for a BDC to a UDC.
