## Problem Statement
{:#problem-statement}

As mentioned in [](#introduction), the hybrid storage solution provided by OSTRICH leads to long unidirectional delta chains,
which can become problematic for RDF archives with many versions in terms of ingestion time, storage size and query execution time.
Our goal in this work is to investigate if these issues can be alleviated by modifying the delta chain structure.

We formulate our research question as follows:
<q id="research-question">How can we improve the storage of RDF archives under the hybrid storage strategy by modification of the delta chain structure?</q>

Concretely, we start from the storage approach from OSTRICH, and we apply two modifications:

1. Creation of new snapshots, which leads to multiple delta chains.
2. Introduction of bidirectional delta chains using reverse deltas.

Since both of these modifications will reduce the length of delta chains,
we expect that this will reduce ingestion time, overall storage size, and average query execution time for all query atoms.
Based on this, we define the following hypotheses:

1. {:#hypothesis-qualitative-storage}
Storage size will be significantly lower for a bidirectional delta chain compared to a unidirectional delta chain.
2. {:#hypothesis-qualitative-ingestion}
In-order ingestion time will be lower for a unidirectional delta chain compared to a bidirectional delta chain.
3. {:#hypothesis-qualitative-querying-vm}
The mean VM query execution will be lower for a unidirectional delta chain compared to a bidirectional delta chain.
4. {:#hypothesis-qualitative-querying-dm}
The mean DM query execution will be lower for a unidirectional delta chain compared to a bidirectional delta chain.
5. {:#hypothesis-qualitative-querying-vq}
The mean VQ query execution will be lower for a unidirectional delta chain compared to a bidirectional delta chain.
