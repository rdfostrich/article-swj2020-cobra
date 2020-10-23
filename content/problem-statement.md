## Problem Statement
{:#problem-statement}

As mentioned in [](#introduction), the hybrid storage solution provided by OSTRICH leads to long delta chains,
which can become problematic for RDF archives with many versions.
Our goal in this work is to investigate if these issues can be alleviated by modifying the delta chain structure.

<span class="comment" data-author="RV">But now, we're presenting it too much as an OSTRICH task. Shall we instead look at the broader research problem of how delta compression for RDF works? And then have OSTRICH as the approach/implementation/validation, not the problem? As we do in the research question below, really.</span>

We formulate our research question as follows:
<q id="research-question">How can we improve the storage of RDF archives under the hybrid storage strategy by modification of the delta chain structure?</q>

Concretely, we start from the hybrid storage approach from OSTRICH,
and we modify its current *unidirectional delta chain* (UDC) into a *bidirectional delta chain* (BDC).
<span class="comment" data-author="RV">Should we perhaps talk about a forward chain into bidirectional? Just wondering.</span>
This bidirectional delta chain consists of two smaller delta chains,
with respectively reverse and forward deltas, all pointing to one common intermediary snapshot.
Since these modifications will reduce the maximum length of a delta chain, without requiring more snapshots,
we expect that this will reduce ingestion time, overall storage size, and query execution time for all query atoms.
Based on this, we define the following hypotheses:

<span class="comment" data-author="RV">…for a typical dataset?</span>

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
