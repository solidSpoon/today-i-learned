# Table Columns and explanations

## ID

This id will represent the id of the statement MySQL is going to execute in order.

If you have a normal query you will see only 1.

But, if you have a joined query and a subquery you will notice it will show you **main** query then **subquery** 2nd then the **join** 3rd.

Important to know the order

## Select Type

As for this, It could have one of the following values (the [] is the focus):

- SubQuery: ex. (select actor_id, [select … from..etc] as something from the table)

- Derived: ex. select * from [select * from something_else]

- Union: join, union or such commands

- Union Result: the place where it joins the results of all joins.

## Table

This will refer to the table it's getting the data from for current query, sometimes it says instead of the table name <derived4> meaning that this join will wait for its internal command id=4 as a table to get data from. usually, its always like that for join commands.

## Type

Some say its called `access_type` , and those types are:

- ALL: find data in the table through normal scan (normal select queries)

- index: find data through an indexed column (nice to be this way)

- range: meaning it can limit the results based on the indexed column and take a range (fast query)

- ref: meaning this will match a ref from other tables

- eq_ref: if the ref to a unique key, meaning it will stop the moment it matches a row

- const, system: matches a const (very fast usually)

## Possible Keys

This will try to take all the columns used in the query and use them as possible columns to filter upon or use for execution.

## Key

The one index that MySQL decided to use to optimize the access of the wanted data.

## Key_len

The number of bytes MySql will use in the index. based on this value you can either play with your query to reduce the effect or change the structure of your tables to a better one if you weren't using the allocated bytes in your table.

## Ref

This shows which columns or constants are being used to lookup values in the index name in the key column.

## Rows

The number of rows MySQL estimate it will need to read to find the desired row.

## Filtered

The percentage of rows that will be filtered by using where conditions or things like that. if you multiply this with `rows` you will get how many rows this query will return to preceding queries.

## Extra

This contains some extra variant data like (` Using index``,` `Using where`..) which shows how the filtering and data picking is going to happen. read more about it in [the documentation](https://dev.mysql.com/doc/refman/8.0/en/explain-output.html).