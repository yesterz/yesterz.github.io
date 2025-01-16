---
title: "List differences: DTO, VO, Entity, Domain, Model"
author: 
date: 2024-12-02 11:17:06 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: true
mermaid: true
---

from <https://stackoverflow.com/questions/72025894/list-differences-dto-vo-entity-domain-model>

1. Entity - is a class with an ID. In the case of relational DB it's usually a class that's mapped to a DB table with some primary key.

2. DTO (Data Transfer Object) - is a class that maps well on what you're sending over the network. E.g. if you exchange JSON or XML data, it usually has fields just enough to fill those requests/responses. Note, that it may have fewer or more fields than Entity.

3. VO (Value Object) is a class-value. E.g. you could create class like Grams or Money - it will contain some primitives (e.g. some double value) and it's possible to compare Value Objects using these primitives. They don't have a database ID. They help replacing primitives with more object-oriented classes related to our particular domain.

4. Domain Model contains all Entities and Value Objects. And some other types of classes depending on the classification you use.