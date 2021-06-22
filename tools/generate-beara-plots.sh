#!/bin/bash
storages="vm dm vq"
queries="o-high o-low p-high p-low po-high po-low s-high s-low so-low sp-high sp-low spo"
for storage in ${storages[@]}; do
    tools/tikz2svg.sh content/img/query/results_beara-$storage-summary.tex
    for query in ${queries[@]}; do
        tmp="content/img/query/result_beara-$storage-$query.tex"
        cp content/img/query/results_beara-template-$storage.tex $tmp
        querycobra=$(echo "$query" | sed "s/-/-queries-/" | sed "s/high/highCardinality/" | sed "s/low/lowCardinality/" | sed "s/spo/spo-queries/")
        gsed -i "s/QUERY_COBRA/$querycobra/" $tmp
        gsed -i "s/QUERY/$query/" $tmp
        tools/tikz2svg.sh $tmp
        rm $tmp
    done
done

