## Evaluation
{:#evaluation}

In this section, we evaluate our bidirectional archiving approach by comparing our implementation to native OSTRICH.

### Implementation
{:#evaluation-implementation}

We have implemented our storage approach and query algorithms in a tool called COBRA (Change-Based Offset-Enabled Bidirectional RDF Archive).
COBRA is an extension of OSTRICH, has been implemented in C/C++, and is available under the MIT license on [GitHub](https://github.com/rdfostrich/cobra){:.mandatory}.
Our implementation uses [HDT](cite:cites hdt) as snapshot technology,
and makes use of the highly efficient memory-mapped B+Tree implementation [Kyoto Cabinet](http://fallabs.com/kyotocabinet/){:.mandatory} for storing our indexes.
The delta dictionary is encoded with [gzip](http://www.gzip.org/), which requires decompression during querying and ingestion.

### Experimental Setup
{:#evaluation-setup}

In order to evaluate the ingestion and triple pattern query execution of COBRA,
we make use of the [BEAR benchmark](https://aic.ai.wu.ac.at/qadlod/bear.html){:.mandatory}.
To test the scalability of our approach for datasets with few and large versions, we use the BEAR-A benchmark.
We use the ten eight versions of the BEAR-A dataset (more versions cause memory issues),
which contains 30M to 66M triples per version.
This dataset was compiled from the [Dynamic Linked Data Observatory](http://swse.deri.org/dyldo/).
To test for datasets with many smaller versions, we use BEAR-B with the daily and hourly granularities.
The daily dataset contains 89 versions and the hourly dataset contains 1,299 versions,
both of them have around 48K triples per version.
All experiments were performed on a 64-bit Ubuntu 14.04 machine with a 6-core 2.40 GHz CPU and 48 GB of RAM.
Our experimental setup and its raw results are available on [GitHub](https://github.com/rdfostrich/cobra/tree/master/Experiments/Results){:.mandatory}.

During our experiments, we distinguish between the following storage approaches:

* **OSTRICH**: OSTRICH with a forward unidirectional aggregated delta chain ([](#evaluation-storage-approaches-ostrich))
* **COBRA\***: COBRA with a bidirectional aggregated delta chain before fix-up ([](#evaluation-storage-approaches-cobra-star))
* **COBRA**: COBRA with a bidirectional aggregated delta chain after fix-up ([](#evaluation-storage-approaches-cobra))

In the scope of this work, we work with at most two delta chains.
For simplicity of these experiments, we always start a new delta chain in the middle version of the dataset
(4 for BEAR-A, 45 for BEAR-B Daily, 200 for BEAR-B Hourly).
Note that for the COBRA storage approach, we assume that all versions are available beforehand,
so they can be stored out of order, starting with the middle snapshot.
In practise, this may not always be possible, which is why we report on the additional fix-up time during ingestion separately
that would be required when ingestion in order (COBRA\*).

<figure id="evaluation-storage-approaches" class="figure">

<figure id="evaluation-storage-approaches-ostrich" class="subfigure">
<img src="img/approach-ostrich.png" alt="OSTRICH storage approach">
<figcaption markdown="block">
OSTRICH with a forward unidirectional aggregated delta chain
</figcaption>
</figure>

<figure id="evaluation-storage-approaches-cobra-star" class="subfigure">
<img src="img/approach-cobra-star.png" alt="COBRA* storage approach">
<figcaption markdown="block">
COBRA with a bidirectional aggregated delta chain before fix-up
</figcaption>
</figure>

<figure id="evaluation-storage-approaches-cobra" class="subfigure">
<img src="img/approach-cobra.png" alt="COBRA storage approach">
<figcaption markdown="block">
COBRA with a bidirectional aggregated delta chain after fix-up (ingested out-of-order starting with snapshot)
</figcaption>
</figure>

<figcaption markdown="block">
The different storage approaches used in our experiments.
</figcaption>
</figure>

To evaluate triple pattern query performance,
we make use of the query sets provided by BEAR.
BEAR-A provides 7 query sets containing around 100 triple patterns that are further divided in high result cardinality and low result cardinality. 
BEAR-B provides two query sets that contain ?P? and ?PO queries.
We evaluate these queries as VM queries for all version, DM queries between all versions and a VQ query.
In order to minimize outliers, we replicate the queries five times and take the mean results.
Furthermore, we perform a warm-up period before the first query of each triple pattern.
Since neither OSTRICH nor COBRA support multiple snapshots for all query atoms,
we limit our experiments to OSTRICH’s unidrectional storage layout and COBRA’s bidirectional storage layout.

### Results
{:#evaluation-results}

In this section, we discuss the results of our experiments on ingestion and query evaluation.

#### Ingestion

[](#ingestion-beara), [](#ingestion-bearbd) and [](#ingestion-bearbh) show the total storage sizes and ingestion times
for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
These tables show that COBRA less ingestion time than OSTRICH in all cases (41% less on average).
Furthermore, COBRA requires less storage space than OSTRICH for BEAR-A and BEAR-B Hourly, but not for BEAR-B Daily.
COBRA* requires more storage space than both COBRA and OSTRICH with BEAR-A, but it requires less ingestion time.
For BEAR-B Daily, OSTRICH requires less storage, but COBRA* has the lowest ingestion time.
For BEAR-B Hourly, COBRA* is lower in terms of storage size and ingestion time than both COBRA and OSTRICH.

<figure id="ingestion-beara" class="table" markdown="1">

| Approach | Storage Size (GB) | Ingestion Time (hours) |
|----------|:------------------|:-----------------------|
| OSTRICH  | 3.92              | 23.66                  |
| COBRA*   | 4.31              | *12.92*                |
| COBRA    | *3.36*            | 14.63                  |

<figcaption markdown="block">
Total storage size and ingestion time for BEAR-A,
with COBRA requiring the least storage size,
and COBRA* the least ingestion time.
</figcaption>
</figure>

<figure id="ingestion-bearbd" class="table" markdown="1">

| Approach | Storage Size (MB) | Ingestion Time (minutes) |
|----------|:------------------|:-------------------------|
| OSTRICH  | *19.37*           | 6.53                     |
| COBRA*   | 26.01             | *3.28*                   |
| COBRA    | 28.44             | 4.24                     |

<figcaption markdown="block">
Total storage size and ingestion time for BEAR-B Daily,
with COBRA* being the smallest and fastest.
</figcaption>
</figure>

<figure id="ingestion-bearbh" class="table" markdown="1">

| Approach | Storage Size (MB) | Ingestion Time (minutes) |
|----------|:------------------|:-------------------------|
| OSTRICH  | 61.02             | 34.47                    |
| COBRA*   | *46.42*           | *14.87*                  |
| COBRA    | 53.26             | 18.30                    |

<figcaption markdown="block">
Total storage size and ingestion time for BEAR-B Hourly,
with COBRA* being the smallest and fastest.
</figcaption>
</figure>

In order to provide more details on the evolution of storage size and ingestion time,
[](#ingestion-size) shows the cumulative storage size for the different datasets,
and [](#ingestion-time) shows the ingestion time for these datasets.
These figures show the impact of the middle snapshots within the bidirectional chain.
For BEAR-B Daily and Hourly, the storage size significantly increases at the middle version,
but the ingestion times for all later versions significantly reset.

<figure id="ingestion-size" class="figure">

<center>
<img src="img/results/legend-ingestion.png" alt="Legend" class="results-legend">
</center>

<figure id="ingestion-size-beara" class="subfigure">
<img src="img/results/beara-ingestion-size.png" alt="BEAR-A Ingestion Size" class="results-triple">
<figcaption markdown="block">
BEAR-A
</figcaption>
</figure>

<figure id="ingestion-size-bearbd" class="subfigure">
<img src="img/results/bearbd-ingestion-size.png" alt="BEAR-B Daily Ingestion Size" class="results-triple">
<figcaption markdown="block">
BEAR-B Daily
</figcaption>
</figure>

<figure id="ingestion-size-bearbh" class="subfigure">
<img src="img/results/bearbh-ingestion-size.png" alt="BEAR-B Hourly Ingestion Size" class="results-triple">
<figcaption markdown="block">
BEAR-B Hourly
</figcaption>
</figure>

<figcaption markdown="block">
Cumulative storage sizes for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
COBRA requires less storage space than OSTRICH for BEAR-A.
For BEAR-B Daily and Hourly, the middle snapshot leads to a significant increase in storage size.
</figcaption>
</figure>

<figure id="ingestion-time" class="figure">

<center>
<img src="img/results/legend-ingestion.png" alt="Legend" class="results-legend">
</center>

<figure id="ingestion-time-beara" class="subfigure">
<img src="img/results/beara-ingestion-time.png" alt="BEAR-A Ingestion Time" class="results-triple">
<figcaption markdown="block">
BEAR-A
</figcaption>
</figure>

<figure id="ingestion-time-bearbd" class="subfigure">
<img src="img/results/bearbd-ingestion-time.png" alt="BEAR-B Daily Ingestion Time" class="results-triple">
<figcaption markdown="block">
BEAR-B Daily
</figcaption>
</figure>

<figure id="ingestion-time-bearbh" class="subfigure">
<img src="img/results/bearbh-ingestion-time.png" alt="BEAR-B Hourly Ingestion Time" class="results-triple">
<figcaption markdown="block">
BEAR-B Hourly
</figcaption>
</figure>

<figcaption markdown="block">
Ingestion times per version for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
COBRA resets ingestion time from the snapshot version, while ingestion time for OSTRICH keeps increasing.
</figcaption>
</figure>

Finally, [](#ingestion-fixup-time) show the fix-up times,
which are measured as a separate offline process.
This is the time it would take to transition from the COBRA\* to COBRA storage approach,
when the versions could not be inserted out of order.
On average, this fix-up requires 3,6 times more time compared to the additional time out of order ingestion takes.

<figure id="ingestion-fixup-time" class="table" markdown="1">

| Dataset       | Time          |
|---------------|:--------------|
| BEAR-A        | 8.38 hours    |
| BEAR-B Daily  | 2.48 minutes  |
| BEAR-B Hourly | 11.41 minutes |

<figcaption markdown="block">
Fix-up duration for the different datasets.
</figcaption>
</figure>

#### Query Evaluation

[](#query-vm), [](#query-dm) and [](#query-vq) show the query evaluation times
for COBRA (after fix-up) and OSTRICH for respectively VM, DM and VQ.
These figures show that for VM, COBRA is faster than OSTRICH minus a few outliers around the middle version.
For DM, COBRA is always faster than OSTRICH when querying within the first half of its delta chain.
For the second half, COBRA becomes slower, and for BEAR-B Daily even becomes slower than OSTRICH.
For VQ, COBRA is faster than OSTRICH for BEAR-B Hourly, slightly faster for BEAR-B Daily, and slower for BEAR-A.

<figure id="query-vm" class="figure">

<center>
<img src="img/results/legend-query.png" alt="Legend" class="results-legend">
</center>

<figure id="query-vm-beara" class="subfigure">
<img src="img/results/beara-query-vm.png" alt="BEAR-A VM" class="results-triple">
<figcaption markdown="block">
BEAR-A
</figcaption>
</figure>

<figure id="query-vm-bearbd" class="subfigure">
<img src="img/results/bearbd-query-vm.png" alt="BEAR-B Daily VM" class="results-triple">
<figcaption markdown="block">
BEAR-B Daily
</figcaption>
</figure>

<figure id="query-vm-bearbh" class="subfigure">
<img src="img/results/bearbh-query-vm.png" alt="BEAR-B Hourly VM" class="results-triple">
<figcaption markdown="block">
BEAR-B Hourly
</figcaption>
</figure>

<figcaption markdown="block">
Version Materialization evaluation times per version for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
For most versions, COBRA has is faster than OSTRICH.
</figcaption>
</figure>

<figure id="query-dm" class="figure">

<center>
<img src="img/results/legend-query.png" alt="Legend" class="results-legend">
</center>

<figure id="query-dm-beara" class="subfigure">
<img src="img/results/beara-query-dm.png" alt="BEAR-A DM" class="results-triple">
<figcaption markdown="block">
BEAR-A
</figcaption>
</figure>

<figure id="query-dm-bearbd" class="subfigure">
<img src="img/results/bearbd-query-dm.png" alt="BEAR-B Daily DM" class="results-triple">
<figcaption markdown="block">
BEAR-B Daily
</figcaption>
</figure>

<figure id="query-dm-bearbh" class="subfigure">
<img src="img/results/bearbh-query-dm.png" alt="BEAR-B Hourly DM" class="results-triple">
<figcaption markdown="block">
BEAR-B Hourly
</figcaption>
</figure>

<figcaption markdown="block">
Delta Materialization evaluation times between the first version and all other versions
for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
For the first half of versions, COBRA is faster than OSTRICH.
For the second half of versions, COBRA becomes slower, but still faster than OSTRICH for BEAR-A and BEAR-B Hourly.
</figcaption>
</figure>

<figure id="query-vq" class="figure">

<figure id="query-vq-beara" class="subfigure">
<img src="img/results/beara-query-vq.png" alt="BEAR-A VQ" class="results-triple">
<figcaption markdown="block">
BEAR-A
</figcaption>
</figure>

<figure id="query-vq-bearbd" class="subfigure">
<img src="img/results/bearbd-query-vq.png" alt="BEAR-B Daily VQ" class="results-triple">
<figcaption markdown="block">
BEAR-B Daily
</figcaption>
</figure>

<figure id="query-vq-bearbh" class="subfigure">
<img src="img/results/bearbh-query-vq.png" alt="BEAR-B Hourly VQ" class="results-triple">
<figcaption markdown="block">
BEAR-B Hourly
</figcaption>
</figure>

<figcaption markdown="block">
Version Query evaluation times across all versions for BEAR-A, BEAR-B Daily, and BEAR-B Hourly under the different storage approaches.
COBRA is faster than OSTRICH for the BEAR-B datasets, but slower for BEAR-A.
</figcaption>
</figure>

[](#query-avg-beara), [](#query-avg-bearbd) and [](#query-avg-bearbh) respectively show
the average overall query evaluation times for BEAR-A, BEAR-B Daily and BEAR-B Hourly.
This shows that on average, COBRA is faster than OSTRICH,
except for VQ in BEAR-A.

<figure id="query-avg-beara" class="table" markdown="1">

| Dataset       | VM      | DM      | VQ      |
|---------------|:--------|:--------|:--------|
| OSTRICH       | 5.64    | 4,15    | *8,60*  |
| COBRA         | *4.37*  | *2,93*  | 10,62   |

<figcaption markdown="block">
Average query evaluation times for OSTRICH and COBRA for VM, DM and VQ for BEAR-A (ms).
</figcaption>
</figure>

<figure id="query-avg-bearbd" class="table" markdown="1">
| Dataset       | VM      | DM      | VQ      |
|---------------|:--------|:--------|:--------|
| OSTRICH       | 0,71    | 0,38    | 0.90.   |
| COBRA         | *0,51*  | *0,31*  | *0.89*  |

<figcaption markdown="block">
Average query evaluation times for OSTRICH and COBRA for VM, DM and VQ for BEAR-B Daily (ms).
</figcaption>
</figure>

<figure id="query-avg-bearbh" class="table" markdown="1">

| Dataset       | VM      | DM      | VQ      |
|---------------|:--------|:--------|:--------|
| OSTRICH       | 0.73    | 0.27    | 1,72    |
| COBRA         | *0.53*  | *0.19*  | *1,34*  |

<figcaption markdown="block">
Average query evaluation times for OSTRICH and COBRA for VM, DM and VQ for BEAR-B Hourly (ms).
</figcaption>
</figure>

### Discussion
{:#evaluation-discussion}

In this section, we discuss the findings of our results regarding ingestion and query evaluation,
and we test our hypotheses.

#### Ingestion

Our experimental results show that the usage of a bidirectional delta chain has a significant impact
on storage size and ingestion time compared to a unidirectional delta chain.
While the unidirectional delta chain leads to increasing ingestion times for every new version,
initiating a new snapshot (COBRA\*) can effectively _reset_ these ingestion times.
The downside of this is that there is a clear increase in storage size due to this,
which is more significant for datasets that have many small versions (BEAR-B).
As such, for such datasets (BEAR-B), it is recommended to wait longer before initiating a new snapshot in the delta chain,
since ingestion times are typically much lower compared to datasets with fewer large versions (BEAR-A).
Given the capabilities and query load of the server and affordable storage overhead,
a certain ingestion time threshold could be defined,
which would initiate a new snapshot when this threshold is exceeded.

Once there are two unidirectional delta chains,
the first one could optionally be reversed so that both can share one snapshot through a fix-up process (COBRA).
Our results show that this can further reduce storage size for datasets with few large versions (BEAR-A).
However, for many small versions (BEAR-B), this leads to additional storage overhead.
This fix-up process does however require a significant execution time.
However, since this could easily run in a separate process can happen in an offline process,
this additional time is typically not a problem.
As such, when the server encounters a dataset with large versions (millions of triples per version),
then the fix-up process should be applied.

The results also show that if all versions are known beforehand,
they should be ingested out-of-order into a bidirectional delta chain.
Because this leads to a significantly lower total ingestion time
compared to in-order ingestion followed by the fix-up process.

#### Query Evaluation

Regarding query performance, our results show that the bidirectional delta chain also has a large impact here.
Since two shorter delta chains lead to two smaller addition and deletion indexes compared to one longer delta chain,
VM and DM times become lower, since less data needs to be iterated.
We see that DM times for the second half of the bidirectional delta chain become slower compared to the first half.
This is because in these cases we need to query within the two parts of the delta chain,
i.e., we need to search through two addition and deletion indexes instead of just one.
For datasets with many small versions (BEAR-B),
VQ also becomes faster with a bidirectional delta chain,
but this does not apply when the dataset has few large versions (BEAR-A).
The reason for this again has to do with the fact that we now have two delta chains,
and two addition and deletion indexes to query in.
When we have many small versions, these two delta chains are worth it,
as their impact on performance outweighs the impact of the snapshot.
However, for few large versions,
the overhead of two delta chains is too large for VQ,
and one delta chain is more performant.
In summary, a bidirectional delta chain is most effective for optimizing VM,
largely beneficial for DM,
and beneficial for VQ (assuming many small versions).

#### Hypotheses

In [](#problem-statement), we defined research hypotheses,
which we will now answer based on our experimental results.
In our [first hypothesis](#hypothesis-qualitative-storage), we expected storage size
to become lower with a bidirectional delta chain compared to a unidirectional delta chain.
While this is true for BEAR-A and BEAR-B Hourly, this is not true for BEAR-B Daily.
As such, we _reject_ this hypotheses.
In our [second hypothesis](#hypothesis-qualitative-ingestion),
we expected ingestion time to be higher with a bidirectional delta chain.
Our results show that the opposite is true, and ingestion into a bidirectional delta chain is in fact _faster_ than for a unidirectional delta chain.
As such, we also _reject_ this hypothesis.
Our other hypotheses expect that evaluation times for [VM](#hypothesis-qualitative-querying-vm),
[DM](#hypothesis-qualitative-querying-dm) and [VQ](#hypothesis-qualitative-querying-vq)
with a bidirectional delta chain would be lower.
Our results show that this is true, expect for VQ.
As such, we _accept_ our [third](#hypothesis-qualitative-querying-vm) and [fourth](#hypothesis-qualitative-querying-dm) hypothesis,
and _reject_ our [fifth](#hypothesis-qualitative-querying-vq) hypothesis.
