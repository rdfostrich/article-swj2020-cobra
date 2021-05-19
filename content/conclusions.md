## Conclusions
{:#conclusions}

In this work, we improved the storage of RDF archives
under the hybrid storage strategy (OSTRICH)
by making use of a *bidirectional delta chain*.
Based on our implementation of this new approach (COBRA),
our experimental results show that this modification
leads to more efficient ingestion (41% faster) compared to a unidirectional delta chain (OSTRICH).
This change also reduces total storage size (13% lower) for two out of three datasets.
Furthermore, all versioned query types achieve a performance boost (21% faster),
except for VQ under the BEAR-A dataset.
With query execution times in the order of 1 millisecond or less,
the bidirectional delta chain strategy from COBRA is an ideal back-end for RDF archives in the context of Web querying,
as network latency is typically slower than that.

As such, the bidirectional delta chain is a viable alternative to the unidirectional delta chain,
as it is beneficial across nearly all metrics.
We **recommend bidirectional delta chains** when any of the following is needed (in order of importance):

* **Lower ingestion times**
* **Faster VM and DM**
* **Lower storage sizes**

On the other hand, we **do not recommend bidirectional delta chains** in the following cases:

* **Fast VQ is needed over datasets with very large versions**: Bidirectional chains slow down VQ when versions are large.
* **Dataset has only a few small versions**: Unidirectional chain should be used until the ingestion of a new version exceeds the ingestion time of a new snapshot.

These limitations of a bidirectional delta chain
may be resolvable in future work through more intelligent strategies on
when to convert a unidirectional delta chain into a bidirectional delta chain.
Next to this, the beneficial impact of the bidirectional delta chain opens up questions
as to what respect other transformations of the delta chain in terms of delta directionality and snapshot placement
may be beneficial to ingestion time, storage size, and query performance.
First, deltas may inherit from two or more surrounding versions, instead of just one.
Second, aggregated and non-aggregated deltas are just two extremes of delta organization.
A range of valuable possibilities in between may exist,
such as inheriting from the n<sup>th</sup> largest preceding version.
Third, the impact of multiple snapshots and strategies to decide when to create them still remain as open questions,
which we suspect will be crucial for RDF archiving for indefinitely increasing numbers of versions.

While these findings show that a bidirectional delta chain is mostly more beneficial than a unidirectional delta chain for the same version range,
neither approaches will scale to an infinite number of versions.
Therefore, investigating creation of multiple snapshots in future work to create new delta chains will be crucial for solving scalability issues
when ingesting (theoretically) infinite numbers of version.
While we expect that the creation and querying of multiple delta chains will be significantly more expensive than a single delta chain,
the use of bidirectional chains can delay their need by a factor of 2 compared to unidirectional delta chains.

We have shown that modifying the structure of the delta chain can be highly beneficial for RDF archiving.
This brings us closer to an efficient queryable Semantic Web that can evolve and maintain its history.
