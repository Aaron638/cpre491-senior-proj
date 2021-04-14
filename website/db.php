<?php
		$mysql_user= 'sample';
		$mysql_password = 'ohpn732w';
		$my_database = 'sample_db';
		$my_table = 'test';
		

echo "<h1> Database Test</h1>\n";

// Connecting, selecting database
$link = mysql_connect($mysql_host, $mysql_user, $mysql_password)
    or die('Could not connect: ' . mysql_error());
echo 'Connected successfully';
mysql_select_db($my_database) or die('Could not select database');

echo "<br />\n";

// Performing SQL query
echo "CREATE TABLE <br />\n";
$query = "CREATE TABLE IF NOT EXISTS $my_table ( id INT AUTO_INCREMENT KEY, name VARCHAR(35) )";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());

// Performing SQL query
echo "INSERT DATA <br />\n";
$query = "INSERT INTO $my_table (name) VALUES('A'),('B'),('C');";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());


// Performing SQL query
echo "SELECT DATA <br />\n";
$query = "SELECT * FROM $my_table";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());

// Printing results in HTML
echo "<table>\n";
    echo "\t<tr><th>ID</th><th>Name</th></tr>\n";
while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Free resultset
mysql_free_result($result);


// Performing SQL query
echo "DROP TABLE <br />\n";
$query = "DROP TABLE $my_table";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());

// Closing connection
mysql_close($link);

echo "DONE<br />\n";


?>

