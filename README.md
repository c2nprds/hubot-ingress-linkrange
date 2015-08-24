Hubot Ingress Link Range
==========
A Hubot script for ingress link range calculation

Installing
----------
```
npm install hubot-ingress-linkrange --save
```
Then add **hubot-ingress-linkrange** to your external-scripts.json:
```
[
  "hubot-ingress-linkrange"
]
```

Usage
-----
```
hubot linkrange <levels> <linkamps> - get link range, <levels=[1-8]{8}> <linkamps=VRLA,ULA,LA>
hubot linkrange 12345678 VRLA,ULA,LA
```
