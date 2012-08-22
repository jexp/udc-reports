Offers a simple reporting front-end for the Neo4j UDC information

Uses the cypher endpoint of the UDC-graph: https://dashboard.neo4j.org/api/query.json

     curl -H accept:application/json \
     -d'{"query":"start n=node(0) return n"}'  \
     https://dashboard.neo4j.org/api/query.json

Results in json like:

    {"columns":["n"],"data":[[{"self":"/node/0","data":{"lastImportDate":1345350298000,"versions":["1.3",...,"1.8.M08"]

It can also consume an array of those query/param maps and will then return an array of results.

Alternatively with a `-H neo4j.cypher.compact:true' header it will return a more compact format.

This app offers a single endpoint /reports[?date=yyyy-mm-dd]

which gives an udc-report for the month or week given (or now).