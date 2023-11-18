9.4 User-Defined Variables
--------------------------

You can store a value in a user-defined variable in one statement and refer to it later in another statement. This enables you to pass values from one statement to another.

您可以在一个语句中将值存储在用户定义的变量中，稍后在另一个语句中引用它。这使您能够将值从一个语句传递到另一个语句。

User variables are written as `@var_name`, where the variable name `var_name` consists of alphanumeric characters, `.`, `_`, and `$`. A user variable name can contain other characters if you quote it as a string or identifier (for example, `@'my-var'`, `@"my-var"`, or ``@`my-var` ``).

用户变量写成 `@var_name` ，其中变量名  `var_name` 由字母数字字符、`.`、`_` 和 `$` 组成。如果将用户变量名称作为字符串或标识符引用，则它可以包含其他字符（例如，`@'my-var'`、`@"my-var"` 或 ``@`my-var` `` ）。

User-defined variables are session specific. A user variable defined by one client cannot be seen or used by other clients. (Exception: A user with access to the Performance Schema [`user_variables_by_thread`](performance-schema-user-variable-tables.html "27.12.10 Performance Schema User-Defined Variable Tables") table can see all user variables for all sessions.) All variables for a given client session are automatically freed when that client exits.

用户定义的变量是特定于会话的。一个客户端定义的用户变量不能被其他客户端看到或使用。 （例外：有权访问 Performance Schema `user_variables_by_thread` 表的用户可以查看所有会话的所有用户变量。）当客户端退出时，给定客户端会话的所有变量都会自动释放。

User variable names are not case-sensitive. Names have a maximum length of 64 characters.

用户变量名不区分大小写。名称的最大长度为 64 个字符。

One way to set a user-defined variable is by issuing a [`SET`](set-variable.html "13.7.6.1 SET Syntax for Variable Assignment") statement:

设置用户定义变量的一种方法是发出“SET”语句：

```sql
SET @_var_name_ = _expr_ [, @_var_name_ = _expr_] ...
```

For [`SET`](set-variable.html "13.7.6.1 SET Syntax for Variable Assignment"), either [`=`](assignment-operators.html#operator_assign-equal) or [`:=`](assignment-operators.html#operator_assign-value) can be used as the assignment operator.

对于 `SET`，`=` 或 `:=` 都可以用作赋值运算符。

User variables can be assigned a value from a limited set of data types: integer, decimal, floating-point, binary or nonbinary string, or `NULL` value. Assignment of decimal and real values does not preserve the precision or scale of the value. A value of a type other than one of the permissible types is converted to a permissible type. For example, a value having a temporal or spatial data type is converted to a binary string. A value having the [`JSON`](json.html "11.5 The JSON Data Type") data type is converted to a string with a character set of `utf8mb4` and a collation of `utf8mb4_bin`.

可以从一组有限的数据类型中为用户变量分配一个值：整数、十进制、浮点、二进制或非二进制字符串，或「NULL」值。十进制和实数值的分配不会保留值的精度或小数位数。将除「允许类型之一」之外的类型的值转换为允许类型。例如，具有时间或空间数据类型的值被转换为二进制字符串。具有「JSON」数据类型的值被转换为具有「utf8mb4」字符集和「utf8mb4_bin」排序规则的字符串。

If a user variable is assigned a nonbinary (character) string value, it has the same character set and collation as the string. The coercibility of user variables is implicit. (This is the same coercibility as for table column values.)

如果为用户变量分配了非二进制（字符）字符串值，则它具有与字符串相同的字符集和排序规则。用户变量的强制性是隐含的。 （这与表列值的强制力相同。）

Hexadecimal or bit values assigned to user variables are treated as binary strings. To assign a hexadecimal or bit value as a number to a user variable, use it in numeric context. For example, add 0 or use [`CAST(... AS UNSIGNED)`](cast-functions.html#function_cast):

分配给用户变量的十六进制或位值被视为二进制字符串。要将十六进制或位值作为数字分配给用户变量，请在数字上下文中使用它。例如，添加 0 或使用 `CAST(... AS UNSIGNED)`

```bash
mysql> SET @v1 = X'41';
mysql> SET @v2 = X'41'+0;
mysql> SET @v3 = CAST(X'41' AS UNSIGNED);
mysql> SELECT @v1, @v2, @v3;
+------+------+------+
| @v1  | @v2  | @v3  |
+------+------+------+
| A    |   65 |   65 |
+------+------+------+
mysql> SET @v1 = b'1000001';
mysql> SET @v2 = b'1000001'+0;
mysql> SET @v3 = CAST(b'1000001' AS UNSIGNED);
mysql> SELECT @v1, @v2, @v3;
+------+------+------+
| @v1  | @v2  | @v3  |
+------+------+------+
| A    |   65 |   65 |
+------+------+------+
```

If the value of a user variable is selected in a result set, it is returned to the client as a string.

如果在结果集中选择了用户变量的值，则将其作为字符串返回给客户端。

If you refer to a variable that has not been initialized, it has a value of `NULL` and a type of string.

如果你引用一个没有被初始化的变量，它的值是 `NULL` 和一个字符串类型。

Beginning with MySQL 8.0.22, a reference to a user variable in a prepared statement has its type determined when the statement is first prepared, and retains this type each time the statement is executed thereafter. Similarly, the type of a user variable employed in a statement within a stored procedure is determined the first time the stored procedure is invoked, and retains this type with each subsequent invocation.

从 MySQL 8.0.22 开始，在准备好的语句中对用户变量的引用在第一次准备语句时确定其类型，并在此后每次执行该语句时保留此类型。类似地，在存储过程中的语句中使用的用户变量的类型是在第一次调用存储过程时确定的，并且在每次后续调用时都保留该类型。

User variables may be used in most contexts where expressions are permitted. This does not currently include contexts that explicitly require a literal value, such as in the `LIMIT` clause of a [`SELECT`](select.html "13.2.10 SELECT Statement") statement, or the ``IGNORE _`N`_ LINES`` clause of a [`LOAD DATA`](load-data.html "13.2.7 LOAD DATA Statement") statement.

用户变量可以在大多数允许表达式的情况下使用。这目前不包括明确需要文字值的上下文，例如在 `SELECT` 语句的 `LIMIT` 子句或 `LOAD DATA` 语句的 ``IGNORE _`N`_ LINES`` 子句中。

Previous releases of MySQL made it possible to assign a value to a user variable in statements other than [`SET`](set-variable.html "13.7.6.1 SET Syntax for Variable Assignment"). This functionality is supported in MySQL 8.0 for backward compatibility but is subject to removal in a future release of MySQL.

以前的 MySQL 版本可以在 SET 以外的语句中为用户变量赋值。 MySQL 8.0 支持此功能以实现向后兼容性，但在 MySQL 的未来版本中可能会被删除。

When making an assignment in this way, you must use [`:=`](assignment-operators.html#operator_assign-value) as the assignment operator; `=` is treated as the comparison operator in statements other than [`SET`](set-variable.html "13.7.6.1 SET Syntax for Variable Assignment").

以这种方式进行赋值时，必须使用`:=`作为赋值运算符； `=` 在 `SET` 以外的语句中被视为比较运算符。

The order of evaluation for expressions involving user variables is undefined. For example, there is no guarantee that `SELECT @a, @a:=@a+1` evaluates `@a` first and then performs the assignment.

涉及用户变量的表达式的求值顺序未定义。例如，不能保证 `SELECT @a, @a:=@a 1` 先评估 `@a` 然后执行赋值。

In addition, the default result type of a variable is based on its type at the beginning of the statement. This may have unintended effects if a variable holds a value of one type at the beginning of a statement in which it is also assigned a new value of a different type.

此外，变量的默认结果类型基于语句开头的类型。如果一个变量在语句的开头保存了一个类型的值，并且在该语句的开头还为它分配了一个不同类型的新值，这可能会产生意想不到的影响。

To avoid problems with this behavior, either do not assign a value to and read the value of the same variable within a single statement, or else set the variable to `0`, `0.0`, or `''` to define its type before you use it.

为避免出现此行为的问题，请不要在单个语句中为同一变量赋值并读取其值，或者将变量设置为 `0`、`0.0` 或 `''` 以定义其类型在你使用它之前。

`HAVING`, `GROUP BY`, and `ORDER BY`, when referring to a variable that is assigned a value in the select expression list do not work as expected because the expression is evaluated on the client and thus can use stale column values from a previous row.

`HAVING`、`GROUP BY` 和 `ORDER BY`，当引用在选择表达式列表中分配了值的变量时，不能按预期工作，因为表达式是在客户端上计算的，因此可以使用前一行中的陈旧列值。

User variables are intended to provide data values. They cannot be used directly in an SQL statement as an identifier or as part of an identifier, such as in contexts where a table or database name is expected, or as a reserved word such as [`SELECT`](select.html "13.2.10 SELECT Statement"). This is true even if the variable is quoted, as shown in the following example:

用户变量旨在提供数据值。它们不能直接在 SQL 语句中用作标识符或标识符的一部分，例如在需要表或数据库名称的上下文中，或用作保留字（例如 `SELECT`）。即使引用了变量也是如此，如下例所示：

```bash
mysql> SELECT c1 FROM t;
+----+
| c1 |
+----+
|  0 |
+----+
|  1 |
+----+
2 rows in set (0.00 sec)
```

```bash
mysql> SET @col = "c1";
Query OK, 0 rows affected (0.00 sec)
```

```bash
mysql> SELECT @col FROM t;
+------+
| @col |
+------+
| c1   |
+------+
1 row in set (0.00 sec)
```

```bash
mysql> SELECT `@col` FROM t;
ERROR 1054 (42S22): Unknown column '@col' in 'field list' 
```

```bash
mysql> SET @col = "`c1`";
Query OK, 0 rows affected (0.00 sec)
```

```bash
mysql> SELECT @col FROM t;
+------+
| @col |
+------+
| `c1` |
+------+
1 row in set (0.00 sec)
```

An exception to this principle that user variables cannot be used to provide identifiers, is when you are constructing a string for use as a prepared statement to execute later. In this case, user variables can be used to provide any part of the statement. The following example illustrates how this can be done:

用户变量不能用于提供标识符这一原则的一个例外是，当您构建一个字符串以用作稍后执行的准备语句时。在这种情况下，用户变量可用于提供语句的任何部分。以下示例说明了如何做到这一点：

```bash
mysql> SET @c = "c1";
Query OK, 0 rows affected (0.00 sec)

mysql> SET @s = CONCAT("SELECT ", @c, " FROM t");
Query OK, 0 rows affected (0.00 sec)

mysql> PREPARE stmt FROM @s;
Query OK, 0 rows affected (0.04 sec)
Statement prepared

mysql> EXECUTE stmt;
+----+
| c1 |
+----+
|  0 |
+----+
|  1 |
+----+
2 rows in set (0.00 sec)

mysql> DEALLOCATE PREPARE stmt;
Query OK, 0 rows affected (0.00 sec)
```

See [Section 13.5, “Prepared Statements”](sql-prepared-statements.html "13.5 Prepared Statements"), for more information.

A similar technique can be used in application programs to construct SQL statements using program variables, as shown here using PHP 5:

可以在应用程序中使用类似的技术来使用程序变量构造 SQL 语句，如下所示使用 PHP 5：

```php
<?php
$mysqli = new mysqli("localhost", "user", "pass", "test");

if (mysqli_connect_errno()) die("Connection failed: %s\n", mysqli_connect_error());

$col = "c1";

$query = "SELECT $col FROM t";

$result = $mysqli->query($query);

while ($row = $result->fetch_assoc())
{
    echo "<p>" . $row["$col"] . "</p>\n";
}

$result->close();

$mysqli->close();
?>

```

Assembling an SQL statement in this fashion is sometimes known as “Dynamic SQL”.

以这种方式组装 SQL 语句有时称为「动态 SQL」。