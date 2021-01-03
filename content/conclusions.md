## Conclusions
{:#conclusions}

In this work, we improved the storage of RDF archives
under the hybrid storage strategy (OSTRICH)
by making use of a *bidirectional delta chain*.
Based on our implementation of this new approach (COBRA),
our experimental results show that this modification solves
the main scalability problem of OSTRICH regarding its ingestion times.
This change also allows COBRA to reduce total storage size for two out of three datasets.
Furthermore, all versioned query types achieve a performance boost with COBRA,
except for VQ under the BEAR-A dataset.
With query execution times in the order of 1 millisecond or less,
the bidirectional delta chain strategy from COBRA is an ideal back-end in the context of Web querying,
as network latency is typically slower than that.

<span class="comment" data-author="RV">What did we learn about bi-directionality and RDF? Viable or not? (and perhaps use the word <q>viable</q> indeed)</span>

<span class="comment" data-author="RV">I am missing some recommendations here as to what to use when. I wonder if we can lift some of the parts from the analysis section to here (<q>for those datasets (BEAR-B), it is recommended to wait longer before initiating a new snapshot in the delta chain</q>). But I want to understand here: when should I use OSTRICH, COBRA, or wait for something else?
Also tie back to hypotheses and what use cases work well.</span>

This work shows the importance of delta directionality and snapshot placement in the delta chain.
While we have measured the impact of a bidirectional delta chain,
other strategies still remain to be investigated.
<span class="comment" data-author="RV">To achieve what? Which gains are expected?</span>
First, deltas may inherit from two or more surrounding versions, instead of just one.
Second, aggregated and non-aggregated deltas are just two extremes of delta organization.
A range of valuable possibilities in between may exist,
such as inheriting from the n<sup>th</sup> largest preceding version.
Third, the impact of multiple snapshots and strategies to decide when to create them still remain as open questions.
By investigating these different strategies, we can grow towards a truly _evolving_ Semantic Web.

<span class="comment" data-author="RV">Who is impacted by this? What does it mean for archives? For query endpoints?</span>
